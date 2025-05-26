-- Enable UUID generation and encryption functions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";    -- Needed for uuid_generate_v4()
CREATE EXTENSION IF NOT EXISTS "pgcrypto";     -- Useful for password encryption (e.g., crypt())

-- ==========================
-- Create 'users' table
-- ==========================
CREATE TABLE IF NOT EXISTS users (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),  -- Unique user ID generated automatically
    user_email VARCHAR(100) UNIQUE NOT NULL,              -- Email must be unique and not null
    user_password TEXT NOT NULL,                          -- Encrypted password (via pgcrypto)
    user_role VARCHAR(20) NOT NULL CHECK (
        user_role IN ('standard', 'foster_home', 'shelter', 'admin')
    ),                                                    -- Defines user's role
    is_role_verified BOOLEAN DEFAULT FALSE,               -- Whether the role was approved by an admin
    user_first_name VARCHAR(100) NOT NULL,                -- First name
    user_last_name VARCHAR(100) NOT NULL,                 -- Last name
    user_phone_number VARCHAR(20) NOT NULL,                -- Optional phone number
    user_address TEXT,                                    -- Optional address
    create_user_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When the account was created
    user_birth_date DATE NOT NULL,                        -- Optional birthdate
    user_profile_picture TEXT,                             -- Optional URL/path to profile picture
    user_is_verified BOOLEAN DEFAULT FALSE,               -- Whether the user is verified
    CONSTRAINT fk_user_role CHECK (user_role IN ('standard', 'foster_home', 'shelter', 'admin'))
);


-- ==========================
-- Create 'animal_sizes' table
-- ==========================
CREATE TABLE IF NOT EXISTS animal_sizes (
    animal_size_key VARCHAR(30) PRIMARY KEY,               -- Category: small, medium, large
    animal_size_label VARCHAR(50) NOT NULL,                -- Display label: e.g., "Small", "Medium", etc.
    animal_size_description TEXT NOT NULL                  -- Description: e.g., "Up to 10 kg", "10 to 25 kg", etc.
);

-- ==========================
-- Create 'animal_types' table
-- ==========================
CREATE TABLE IF NOT EXISTS animal_types (
    animal_type_key VARCHAR(30) PRIMARY KEY,           -- Unique key for the animal type (e.g., dog, cat, etc.)
    animal_type_label VARCHAR(50) NOT NULL            -- Display label (e.g., "Dog", "Cat", etc.)
);

-- ==========================
-- Create 'foster_homes' table
-- ==========================
CREATE TABLE IF NOT EXISTS foster_homes (
    foster_home_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),  -- Unique ID for foster home
    foster_home_name VARCHAR(100) NOT NULL,                        -- Name of the foster home
    foster_home_description TEXT NOT NULL,                         -- Description of the foster home
    foster_home_capacity INTEGER NOT NULL CHECK (foster_home_capacity > 0),  -- Capacity of the foster home
    foster_home_current_capacity INTEGER NOT NULL CHECK (foster_home_current_capacity >= 0),  -- Current capacity of the foster home
    foster_home_current_occupancy INTEGER NOT NULL CHECK (foster_home_current_occupancy >= 0),  -- Current occupancy of the foster home
    foster_home_website TEXT,                                     -- Optional website for the foster home
    foster_home_address TEXT NOT NULL,                          -- Address of the foster home
    foster_home_phone_number VARCHAR(20) NOT NULL,                       -- Optional phone number for the foster home
    foster_home_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When the foster home was created
    foster_home_update_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When the foster home details were last updated
    foster_home_is_verified BOOLEAN DEFAULT FALSE,              -- Whether the foster home is verified

    user_id UUID,                                               -- Foreign key (user responsible for the foster home)
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE SET NULL  -- Reference to user
);

-- ==========================
-- Create 'shelters' table
-- ==========================
CREATE TABLE IF NOT EXISTS shelters (
    shelter_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),  -- Unique ID for the shelter
    shelter_name VARCHAR(100) NOT NULL,                        -- Name of the shelter
    shelter_address TEXT NOT NULL,                             -- Address of the shelter
    shelter_description TEXT NOT NULL,                         -- Description of the shelter
    shelter_capacity INTEGER NOT NULL CHECK (shelter_capacity > 0),  -- Capacity of the shelter
    shelter_current_capacity INTEGER NOT NULL CHECK (shelter_current_capacity >= 0),  -- Current capacity of the shelter
    shelter_current_occupancy INTEGER NOT NULL CHECK (shelter_current_occupancy >= 0),  -- Current occupancy of the shelter
    shelter_website TEXT,                                      -- Optional website for the shelter
    shelter_phone_number VARCHAR(20) NOT NULL,                          -- Optional phone number for the shelter
    shelter_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- When the shelter was created
    shelter_update_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- When the shelter details were last updated
    shelter_is_verified BOOLEAN DEFAULT FALSE,                 -- Whether the shelter is verified

    user_id UUID,                                              -- Foreign key (user responsible for the shelter)
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE SET NULL  -- Reference to user
);

-- ==========================
-- Create 'animals' table
-- ==========================
CREATE TABLE IF NOT EXISTS animals (
    animal_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),               -- Unique ID for the animal
    animal_name VARCHAR(75) NOT NULL,                                    -- Name of the animal
    animal_age INTEGER,                                                  -- Age (in years)
    animal_gender VARCHAR(20) NOT NULL CHECK (
        animal_gender IN ('male', 'female', 'not_specified')
    ),                                                                   -- Gender with check constraint
    animal_breed VARCHAR(75) NOT NULL,                                            -- Optional breed
    animal_description TEXT NOT NULL,                                             -- Detailed description
    animal_status VARCHAR(25) NOT NULL CHECK (
        animal_status IN ('not_available','available','adopted','fostered','in_shelter')
    ),                                                                   -- Adoption status
    ad_posted_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                  -- When the animal was posted
    ad_update_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                  -- When the animal was last updated
    animal_location TEXT NOT NULL,                                       -- Textual address or location description
    animal_latitude DECIMAL(9,6),                                        -- Latitude (for future geolocation)
    animal_longitude DECIMAL(9,6),                                       -- Longitude (for future geolocation)
    animal_is_verified BOOLEAN DEFAULT FALSE,                            -- Whether the animal is verified

    user_id UUID,                                                        -- Foreign key (user who posted or is responsible)
    shelter_id UUID,                                                     -- Optional link to shelter
    foster_home_id UUID,                                                 -- Optional link to foster home
    animal_type_key VARCHAR(30),                                         -- Type (dog, cat, etc.)
    animal_size_key VARCHAR(30) NOT NULL,                                -- Size (small, medium, large)

    -- Foreign key constraints (all optional; use ON DELETE SET NULL to avoid cascading deletions)
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE SET NULL,  -- Reference to the user who posted the animal
    FOREIGN KEY (shelter_id) REFERENCES shelters (shelter_id) ON DELETE SET NULL,  -- Reference to the shelter
    FOREIGN KEY (foster_home_id) REFERENCES foster_homes(foster_home_id) ON DELETE SET NULL,  -- Reference to foster home
    FOREIGN KEY (animal_type_key) REFERENCES animal_types(animal_type_key) ON DELETE SET NULL,  -- Reference to animal type
    FOREIGN KEY (animal_size_key) REFERENCES animal_sizes(animal_size_key) ON DELETE SET NULL   -- Reference to animal size
);

-- ==========================
-- Create 'reports' table
-- ==========================
CREATE TABLE IF NOT EXISTS reports (
    report_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),     -- Unique ID for the report
    report_title VARCHAR(100) NOT NULL,                         -- Title of the report
    report_type VARCHAR(30) NOT NULL CHECK (
        report_type IN ('lost', 'found', 'abuse', 'other')
    ),                                                          -- Type of the report (e.g., lost, found, abuse)
    report_description TEXT NOT NULL,                           -- Detailed description of the report
    report_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,            -- Date when the report was created
    report_update_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    -- Date when the report was last updated
    report_image_url TEXT,                                      -- URL of the image associated with the report
    report_status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (
        report_status IN ('pending', 'in_progress', 'resolved', 'closed')
    ),                                                          -- Status of the report
    report_address TEXT,                                        -- Street address or specific location
    report_city VARCHAR(100),                                  -- City of the report
    report_province VARCHAR(100),                              -- Province or state
    report_postal_code VARCHAR(15),                            -- Postal or ZIP code
    report_country VARCHAR(100),                               -- Country of the report
    report_latitude DECIMAL(9,6),                                -- Latitude for location
    report_longitude DECIMAL(9,6),                               -- Longitude for location
    report_is_verified BOOLEAN DEFAULT FALSE,                   -- Whether the report is verified
    animal_name VARCHAR(75),                                     -- Animal name
    animal_gender VARCHAR(20) CHECK (
        animal_gender IN ('male', 'female', 'unknown')
    ),                                                           -- Gender of animal
    animal_breed VARCHAR(75),                                    -- Breed of animal
    last_seen_date TIMESTAMP,                                    -- When the animal was last seen

    user_id UUID,                                                -- User who created the report
    animal_type_key VARCHAR(30),                                 -- Type of animal reported
    animal_size_key VARCHAR(30),                                 -- Size of animal reported

    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,  -- Reference to the user who created the report
    FOREIGN KEY (animal_type_key) REFERENCES animal_types(animal_type_key) ON DELETE SET NULL,  -- Reference to animal type
    FOREIGN KEY (animal_size_key) REFERENCES animal_sizes(animal_size_key) ON DELETE SET NULL   -- Reference to animal size
);

-- ==========================
-- Create 'animal_images' table
-- ==========================
CREATE TABLE IF NOT EXISTS animal_images (
    animal_image_id SERIAL PRIMARY KEY,                           -- Unique ID for the animal image
    image_url TEXT NOT NULL,                                      -- URL of the image
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,              -- Date when the image was uploaded
    image_alternative_text TEXT,                                  -- Alternative text for the image (for accessibility)
    image_description TEXT,                                       -- Description of the image
    is_main_image BOOLEAN DEFAULT FALSE,                          -- Whether it is the main image for the animal
    image_is_verified BOOLEAN DEFAULT FALSE,                      -- Whether the image is verified by an admin

    animal_id UUID NOT NULL,                                      -- Reference to the animal associated with the image
    FOREIGN KEY (animal_id) REFERENCES animals(animal_id) ON DELETE CASCADE  -- Foreign key to animals table
);

-- ==========================
-- Create 'adoption_requests' table
-- ==========================
CREATE TABLE IF NOT EXISTS adoption_requests (
    adoption_request_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),  -- Unique ID for the request
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,                 -- When the request was made
    request_update_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,         -- When the request was last updated
    request_status VARCHAR(20) NOT NULL CHECK (
        request_status IN ('pending', 'approved', 'rejected')
    ),                                                                -- Status of the request
    request_message TEXT,                                            -- Message from the user
    request_response TEXT,                                           -- Response from the shelter or admin
    request_response_date TIMESTAMP,                                 -- When the response was given
    request_is_verified BOOLEAN DEFAULT FALSE,                       -- Whether the request is verified
    request_is_completed BOOLEAN DEFAULT FALSE,                      -- Whether the request is completed

    user_id UUID NOT NULL,                                           -- User who made the request
    animal_id UUID NOT NULL,                                         -- Animal for which the request was made

    UNIQUE (user_id, animal_id),                                     -- Prevent duplicate requests
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (animal_id) REFERENCES animals(animal_id) ON DELETE CASCADE
);

-- ==========================
-- Trigger function to update 'ad_update_date' automatically
-- ==========================
CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.ad_update_date = CURRENT_TIMESTAMP; -- Set update time to current time
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ==========================
-- Trigger attached to 'animals' table to invoke update function before any UPDATE
-- ==========================
CREATE TRIGGER update_animals_timestamp
BEFORE UPDATE ON animals
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

-- ==========================
-- Trigger function to update 'shelter_current_capacity' automatically
-- ==========================
CREATE OR REPLACE FUNCTION update_shelter_capacity()
RETURNS TRIGGER AS $$
BEGIN
  -- Validar que no se exceda la capacidad máxima
  IF NEW.shelter_current_occupancy > NEW.shelter_capacity THEN
    RAISE EXCEPTION 'La ocupación no puede superar la capacidad máxima';
  END IF;

  -- Actualizar la capacidad actual
  NEW.shelter_current_capacity = NEW.shelter_capacity - NEW.shelter_current_occupancy;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ==========================
-- Trigger attached to 'shelters' table to invoke update function before any UPDATE
-- ==========================
CREATE TRIGGER update_shelter_capacity_trigger
BEFORE INSERT OR UPDATE ON shelters
FOR EACH ROW
EXECUTE FUNCTION update_shelter_capacity();

-- ==========================
-- Trigger function to update 'shelter_update_date' automatically
-- ==========================
CREATE OR REPLACE FUNCTION update_shelter_modified_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.shelter_update_date = CURRENT_TIMESTAMP; -- Set shelter update time to current time
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ==========================
-- Trigger attached to 'shelters' table to invoke update function before any UPDATE
-- ==========================
CREATE TRIGGER update_shelters_timestamp
BEFORE UPDATE ON shelters
FOR EACH ROW
EXECUTE FUNCTION update_shelter_modified_column();

-- ==========================
-- Trigger function to update 'foster_home_current_occupancy' automatically
-- ==========================
CREATE OR REPLACE FUNCTION update_foster_home_occupancy()
RETURNS TRIGGER AS $$
BEGIN
  -- Check if the animal is assigned to a foster home
  IF NEW.foster_home_id IS NOT NULL THEN

    -- Verify if the foster home has enough capacity to accommodate the new animal
    IF TG_OP = 'INSERT' THEN
      -- Check if the foster home has reached its maximum capacity
      IF (SELECT foster_home_current_occupancy FROM foster_homes WHERE foster_home_id = NEW.foster_home_id) >=
         (SELECT foster_home_capacity FROM foster_homes WHERE foster_home_id = NEW.foster_home_id) THEN
        -- Raise an exception if the foster home is full
        RAISE EXCEPTION 'Foster home is at full capacity';
      END IF;

      -- Update the occupancy of the foster home when a new animal is added
      UPDATE foster_homes
      SET foster_home_current_occupancy = foster_home_current_occupancy + 1
      WHERE foster_home_id = NEW.foster_home_id;
    END IF;

    -- Update the occupancy of the foster home when an animal is removed
    IF TG_OP = 'DELETE' THEN
      UPDATE foster_homes
      SET foster_home_current_occupancy = foster_home_current_occupancy - 1
      WHERE foster_home_id = OLD.foster_home_id;
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ==========================
-- Trigger attached to 'animals' table to invoke update function after INSERT or DELETE operations
-- ==========================
CREATE TRIGGER update_foster_home_occupancy_trigger
AFTER INSERT OR DELETE ON animals
FOR EACH ROW
EXECUTE FUNCTION update_foster_home_occupancy();

-- ==========================
-- Trigger function to update 'report_update_date' automatically
-- ==========================
CREATE OR REPLACE FUNCTION update_report_modified_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.report_update_date = CURRENT_TIMESTAMP; -- Set report update time to current time
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ==========================
-- Trigger attached to 'reports' table to invoke update function before any UPDATE
-- ==========================
CREATE TRIGGER update_reports_timestamp
BEFORE UPDATE ON reports
FOR EACH ROW
EXECUTE FUNCTION update_report_modified_column();

-- Trigger function
CREATE OR REPLACE FUNCTION update_adoption_request_modified_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.request_update_date = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Attach the trigger to the table
CREATE TRIGGER update_adoption_requests_timestamp
BEFORE UPDATE ON adoption_requests
FOR EACH ROW
EXECUTE FUNCTION update_adoption_request_modified_column();

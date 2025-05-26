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

# PetAdoptionAPI

RESTful API for managing users, animals, adoption requests, shelters, foster homes, animal images, animal types and sizes, and reports of abandoned animals.

---

## Index

- [Description](#description)
- [Technologies Used](#technologies-used)
- [Prerequisites](#prerequisites)
- [Environment Setup](#environment-setup)
- [Running the Project](#running-the-project)
- [Docker (PostgreSQL & PgAdmin)](#docker-postgresql--pgadmin)
- [Endpoints](#endpoints)
- [Notes](#notes)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

---

## Description

**PetAdoptionAPI** is a RESTful API built with ASP.NET Core 9, designed to facilitate animal adoption and management for organizations, foster homes, shelters, and private users.

The backend provides endpoints for:

- **User management:** Registration, roles (standard, foster_home, shelter, admin), profile details and verification.
- **Animal management:** Register, update, list, and search animals available for adoption. Each animal includes details like name, age, gender, breed, size, type, description, location, verification status, and images.
- **Animal types and sizes:** Predefined types (dog, cat, etc.) and sizes (small, medium, large) for animal classification.
- **Animal images:** Upload, list, and manage multiple images per animal (including main image, alt text, description, and verification).
- **Adoption requests:** Users can submit, view, and manage requests to adopt animals, including request messages and status updates.
- **Shelters and foster homes:** Manage data for shelters and foster homes, including description, capacity, verification, address, contact, and related user.
- **Reports:** Users can submit and view reports about lost, found, or abandoned animals, including geolocation, status, animal details, and optional verification.
- **Relational structure:** All models use unique identifiers (UUIDs), clear foreign key relationships, and are mapped with Entity Framework Core. Database extensions, triggers, and functions are provisioned using EF Core migrations.

This API is intended to power a mobile application, web admin panel, or third-party integrations for organizations supporting animal welfare.

---

## Technologies Used

- .NET 9 (ASP.NET Core Web API)
- Entity Framework Core
- PostgreSQL
- Docker (for PostgreSQL and PgAdmin)

---

## Prerequisites

- .NET 9 SDK (**tested on 9.0.106**)
- Docker (recommended for database)
- (Optional) PostgreSQL and PgAdmin installed locally if not using Docker

---

## Environment Setup

**Note:**  
This project was developed and tested with .NET 9.0.106. Using an earlier SDK version may cause build or runtime errors.

1. **Clone the repository**

   ```bash
   git clone https://github.com/ShadeCoder7/pet_app/tree/main/backend/PetAdoptionAPI
   cd PetAdoptionAPI
   ```

2. **Configure the database connection**

   ```json
    {
      "ConnectionStrings": {
        "DefaultConnection": "Host=localhost;Database=adoption_app_db;Username=postgres;Password=tucontraseña"
      }
    }
    ```

3. **(Optional) Use .NET User Secrets for local development**

   ```bash
     dotnet user-secrets set "ConnectionStrings:DefaultConnection" "Host=localhost;Database=adoption_app_db;Username=postgres;Password=tucontraseña"
   ```

---

## Running the Project

1. **Restore dependencies and build the project**

   ```bash
    dotnet restore
    dotnet build
    ```

2. **Create the database migration (if you have made changes or the migration does not exist yet)**

   ```bash
    dotnet ef migrations add InitialCreate
    ```

3. **Apply the migration to the database**

   ```bash
    dotnet ef database update
    ```

4. **Run the API**

   ```bash
    dotnet run
    ```
- By default, the API runs on `https://localhost:7105` or `http://localhost:7105`.

> **Note for Android development:**  
> If you are testing the mobile app using the Android emulator, you must use the host address `10.0.2.2` instead of `localhost` to access the backend API.  
> For example: `http://10.0.2.2:7105/api/...`

---

## Docker (PostgreSQL & PgAdmin)

This project uses Docker Compose to launch PostgreSQL and PgAdmin, with all configuration handled via a `.env` file.

> **Important:**  
> **You do NOT need to manually execute any SQL scripts.**  
> All database objects (tables, extensions like `uuid-ossp` and `pgcrypto`, triggers, and functions) are created automatically by running the EF Core migrations from the C# codebase.  
> The SQL scripts in the `sql/` folder (`schema_full_db.sql`, `triggers_db.sql`, `extensions_db.sql`) are provided **only for manual inspection or for legacy/database admin use** and do not need to be executed as part of the normal application setup.

1. **Example `.env` file**

   ```env
    # PostgreSQL Service
   POSTGRES_USER=testuser
   POSTGRES_PASSWORD=testpassword
   POSTGRES_DB=adoption_app_db
   POSTGRES_PORT=5432
   POSTGRES_VERSION=latest
   POSTGRES_CONTAINER_NAME=postgres_db
   POSTGRES_VOLUME_NAME=postgres_data
   RESTART_POLICY=always

   # PgAdmin Service
   PGADMIN_DEFAULT_EMAIL=testadmin@example.com
   PGADMIN_DEFAULT_PASSWORD=testadminpassword
   PGADMIN_PORT=8080
   PGADMIN_VERSION=latest
   PGADMIN_CONTAINER_NAME=pgadmin
   PGADMIN_VOLUME_NAME=pgadmin_data
    ```
> **These are example values. Replace with your own credentials for development.**


2. **docker-compose.yml**

   ```yaml
    services:
        db:
            image: postgres:${POSTGRES_VERSION:-latest}
            container_name: ${POSTGRES_CONTAINER_NAME:-postgres_db}
            restart: ${RESTART_POLICY:-always}
            environment:
            POSTGRES_DB: ${POSTGRES_DB}
            POSTGRES_USER: ${POSTGRES_USER}
            POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
            ports:
                - "${POSTGRES_PORT}:5432"
            volumes:
                - ${POSTGRES_VOLUME_NAME:-postgres_data}:/var/lib/postgresql/data 

        pgadmin:
            image: dpage/pgadmin4:${PGADMIN_VERSION:-latest}
            container_name: ${PGADMIN_CONTAINER_NAME:-pgadmin}
            restart: ${RESTART_POLICY:-always}
            environment:
                PGADMIN_DEFAULT_EMAIL: ${PGADMIN_DEFAULT_EMAIL}
                PGADMIN_DEFAULT_PASSWORD: ${PGADMIN_DEFAULT_PASSWORD}
            ports:
                - "${PGADMIN_PORT}:80"
            depends_on:
                - db
            volumes:
                - ${PGADMIN_VOLUME_NAME:-pgadmin_data}:/var/lib/pgadmin

    volumes:
        postgres_data:
        pgadmin_data:
    ```
> **These are example values. Replace with your own credentials for development.**

3. **Start the services**

   ```bash
    docker compose up -d
    ```

4. **Access PgAdmin**

   - Use the default email and password from your `.env`.
   - Add a new server in PgAdmin pointing to `db` or `localhost` and use the credentials from your `.env`.

---

## Endpoints

This API provides an interface to manage users, animals, adoption requests, shelters, foster homes, animal images, types, sizes, and reports of abandoned animals.

---

## UserController (`api/user`)

| Method | Route               | Description                           |
|--------|---------------------|---------------------------------------|
| GET    | `/api/user`         | Retrieve all users.                   |
| GET    | `/api/user/{id}`    | Retrieve a specific user by ID.       |
| GET    | `/api/user/firebase/{firebaseUid}`    | Retrieve a specific user by their Firebase UID.       |
| POST   | `/api/user`         | Create a new user.                    |
| PUT    | `/api/user/{id}`    | Update a user by ID.                  |
| DELETE | `/api/user/{id}`    | Delete a user by ID.                  |

---

## AnimalController (`api/animal`)

| Method | Route                | Description                            |
|--------|----------------------|----------------------------------------|
| GET    | `/api/animal`        | Retrieve all animals.                  |
| GET    | `/api/animal/{id}`   | Retrieve a specific animal by ID.      |
| POST   | `/api/animal`        | Create a new animal.                   |
| PUT    | `/api/animal/{id}`   | Update an animal by ID.                |
| DELETE | `/api/animal/{id}`   | Delete an animal by ID.                |

---

## AnimalTypeController (`api/animaltype`)

| Method | Route                        | Description                                 |
|--------|------------------------------|---------------------------------------------|
| GET    | `/api/animaltype`            | Retrieve all animal types.                  |
| GET    | `/api/animaltype/{key}`      | Retrieve a specific type by key.            |

---

## AnimalSizeController (`api/animalsize`)

| Method | Route                        | Description                                 |
|--------|------------------------------|---------------------------------------------|
| GET    | `/api/animalsize`            | Retrieve all animal sizes.                  |
| GET    | `/api/animalsize/{key}`      | Retrieve a specific size by key.            |

---

## AnimalImageController (`api/animalimage`)

| Method | Route                                 | Description                                     |
|--------|---------------------------------------|-------------------------------------------------|
| GET    | `/api/animalimage`                    | Retrieve all animal images.                     |
| GET    | `/api/animalimage/{id}`               | Retrieve a specific image by ID.                |
| GET    | `/api/animalimage/animal/{animalId}`  | Retrieve all images for a specific animal.      |
| POST   | `/api/animalimage`                    | Create a new animal image.                      |
| PUT    | `/api/animalimage/{id}`               | Update an animal image by ID.                   |
| DELETE | `/api/animalimage/{id}`               | Delete an animal image by ID.                   |

---

## FosterHomeController (`api/fosterhome`)

| Method | Route                    | Description                                  |
|--------|--------------------------|----------------------------------------------|
| GET    | `/api/fosterhome`        | Retrieve all foster homes.                   |
| GET    | `/api/fosterhome/{id}`   | Retrieve a specific foster home by ID.       |
| POST   | `/api/fosterhome`        | Create a new foster home.                    |
| PUT    | `/api/fosterhome/{id}`   | Update a foster home by ID.                  |
| DELETE | `/api/fosterhome/{id}`   | Delete a foster home by ID.                  |

---

## ShelterController (`api/shelter`)

| Method | Route                  | Description                                  |
|--------|------------------------|----------------------------------------------|
| GET    | `/api/shelter`         | Retrieve all shelters.                       |
| GET    | `/api/shelter/{id}`    | Retrieve a specific shelter by ID.           |
| POST   | `/api/shelter`         | Create a new shelter.                        |
| PUT    | `/api/shelter/{id}`    | Update a shelter by ID.                      |
| DELETE | `/api/shelter/{id}`    | Delete a shelter by ID.                      |

---

## ReportController (`api/report`)

| Method | Route              | Description                                  |
|--------|--------------------|----------------------------------------------|
| GET    | `/api/report`      | Retrieve all reports.                        |
| GET    | `/api/report/{id}` | Retrieve a specific report by ID.            |
| POST   | `/api/report`      | Create a new report.                         |
| PUT    | `/api/report/{id}` | Update a report by ID.                       |
| DELETE | `/api/report/{id}` | Delete a report by ID.                       |

---

## AdoptionRequestController (`api/adoptionrequest`)

| Method | Route                                         | Description                                      |
|--------|-----------------------------------------------|--------------------------------------------------|
| GET    | `/api/adoptionrequest`                        | Retrieve all adoption requests.                  |
| GET    | `/api/adoptionrequest/{id}`                   | Retrieve a specific request by ID.               |
| GET    | `/api/adoptionrequest/user/{userId}`          | Retrieve requests by user ID.                    |
| GET    | `/api/adoptionrequest/animal/{animalId}`      | Retrieve requests by animal ID.                  |
| POST   | `/api/adoptionrequest`                        | Create a new adoption request.                   |
| PUT    | `/api/adoptionrequest/{id}`                   | Update an adoption request by ID.                |
| DELETE | `/api/adoptionrequest/{id}`                   | Delete an adoption request by ID.                |

---

### Retrieve user by Firebase UID

**GET** `/api/user/firebase/{firebaseUid}`

Retrieve a specific user by their Firebase Authentication UID.

**Example**

```http
    GET /api/user/firebase/a1b2c3d4e5f6
```

**Response**

```json
    {
        "userId": "2f47c3fa-78e2-4e81-8b7a-d7720c7f9e12",
        "firebaseUid": "a1b2c3d4e5f6",
        "userEmail": "ejemplo@email.com",
        "userRole": "standard",
        "userFirstName": "Juan",
        "userLastName": "Pérez",
        "userPhoneNumber": "600000000",
        "userAddress": "Calle Ejemplo",
        "userBirthDate": "1990-01-01T00:00:00Z",
        "userProfilePicture": ""
    }
```

---

## Notes

- The API currently does **not enforce uniqueness** for some fields (e.g., email, phone number).
- Make sure the database access is configured correctly and use HTTPS in production.
- For development, you can easily launch the database and PgAdmin with Docker.
- Add authentication and authorization in production.

---

## Project Structure

PetAdoptionAPI/
│
├── bin/                 # Build output: compiled binaries and temporary files (auto-generated, do not commit)
├── Controllers/         # API controllers
├── Data/                # Database config and DbContext
├── Dtos/                # Data transfer objects
├── Interfaces/          # Service/repository interfaces
├── Migrations/          # Entity Framework Core migrations (database schema change history)
├── Models/              # Main data models
├── obj/                 # Intermediate build files and project artifacts (auto-generated, do not commit)
├── Properties/          # Project metadata and launch settings (launchSettings.json)
├── Services/            # Business logic and data access
├── Program.cs           # Main app config
├── appsettings.json     # App configuration
├── PetAdoptionAPI.csproj    # Project file: dependencies, build configuration, and settings for the .NET application
├── PetAdoptionAPI.http  # HTTP request collection for testing API endpoints (can be used in IDEs like VS Code)
├── PetAdoptionAPI.sln   # Solution file: groups related projects and configurations for the .NET solution
├── Program.cs           # Main application entry point and configuration
├── README.md            # Documentation for the backend project
└

## Notes

- The API currently does **not enforce uniqueness** for some fields (e.g., email, phone number).
- All tables, extensions, triggers, and database objects are created automatically by running the .NET EF Core migrations.  
- The SQL scripts in the `sql/` folder (`schema_full_db.sql`, `triggers_db.sql`, `extensions_db.sql`) are **not required** for standard development or deployment and are provided only for manual inspection or legacy/DBA use.
- Make sure your database access and connection strings are configured correctly.
- For development, you can easily launch the database and PgAdmin using Docker and the provided `.env` file.
- Remember to use HTTPS and secure your production environment.
- **Authentication and authorization must be enabled before deploying to production.**
- Do **not** commit your real `.env` files or production credentials to version control.

---

## Contributing

This project is currently private and under development.  
If you wish to contribute, please contact the maintainer first.

---

## License

MIT License.

---

## Contact

Maintainer: **Eric Moya Carmona**  
Email: **ericmoyacarmona7@gmail.com**


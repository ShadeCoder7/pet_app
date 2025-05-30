# PetAdoptionAPI - REST Endpoints

This API provides an interface to manage users, animals, adoption requests, shelters, foster homes, animal images, types, sizes, and reports of abandoned animals.

---

## UserController (`api/user`)

| Method | Route               | Description                           |
|--------|---------------------|---------------------------------------|
| GET    | `/api/user`         | Retrieve all users.                   |
| GET    | `/api/user/{id}`    | Retrieve a specific user by ID.       |
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

| Method | Route                                 | Description                                      |
|--------|----------------------------------------|--------------------------------------------------|
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

## Notes

- All responses are returned in JSON format.
- `POST` and `PUT` methods expect DTOs (Data Transfer Objects) as the request body.
- IDs are usually in UUID format (`Guid` in C#).

> Currently, the API does not enforce unique constraints on user email, phone number, or other fields. This means that duplicate entries can be created as long as the userId is different. For a production-ready version, it is recommended to implement proper validations to prevent duplicate users.

---

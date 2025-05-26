# SQL Scripts

This folder contains SQL scripts that complement Entity Framework Core migrations and are essential for a complete and functional database setup.

---

## 📄 File Descriptions

- **`extensions_db.sql`**  
  Script to create the required PostgreSQL extensions (`uuid-ossp` and `pgcrypto`).  
  Must be executed **before running any EF Core migrations** that use UUIDs or cryptographic functions.

- **`triggers_db.sql`**  
  Script that creates all triggers and custom functions for advanced database logic.  
  Must be executed **after all EF Core migrations have been applied**.

- **`schema_full_db.sql`**  
  Complete script to create the entire database (tables, relationships, triggers, and functions).  
  Useful for total reconstruction or portability outside of EF Core.  
  **Do not execute this script on a database managed by Entity Framework Core.**

---

## 🚦 **Setup Steps (in order)**

1. **Create the database (if it does not exist):**

    You can do this manually with psql, pgAdmin, or a SQL command:

    ```sql
    CREATE DATABASE <your_database_name>;
    ```

2. **Create PostgreSQL extensions:**

    ```bash
    psql -h <host> -p <port> -U <user> -d <your_database_name> -f /path/to/extensions_db.sql
    ```

3. **Create the initial migration (only needed the first time, after defining your models):**

    ```bash
    dotnet ef migrations add InitialCreate
    ```

    > ⚠️ **Note:**  
    > Run this command **only once**, when there are no migrations yet and after defining your models and DbContext.
    > If your project already contains a `Migrations/` folder with existing migrations, skip this step.

4. **Apply EF Core migrations to create tables and relationships:**

    ```bash
    dotnet ef database update
    ```

    > This command applies all existing migrations to your database.

5. **Create triggers and custom functions:**

    ```bash
    psql -h <host> -p <port> -U <user> -d <your_database_name> -f /path/to/triggers_db.sql
    ```

---

> **Notes:**  
> - Replace `<host>`, `<port>`, `<user>`, `<your_database_name>`, and `/path/to/` with your actual environment values.
> - Always follow this order to avoid errors, especially with UUID columns or triggers depending on tables or extensions.
> - All SQL scripts (`extensions_db.sql`, `triggers_db.sql`) should be versioned in the repository for reproducibility and collaboration.





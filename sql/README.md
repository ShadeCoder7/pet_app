# SQL Scripts

- `schema_full_db.sql`:  
  Complete script to create the entire database (tables, relationships, triggers, and functions).  
  Useful for total reconstruction or portability outside of EF Core.  
  **Do not execute this script on a database managed by Entity Framework Core.**

- `triggers.sql`:  
  Contains only triggers and functions.  
  Execute this script on the database *after* applying EF Core migrations to add the advanced logic that is not managed by EF Core.

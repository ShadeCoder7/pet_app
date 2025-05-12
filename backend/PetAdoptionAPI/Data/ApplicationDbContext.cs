// pet_app/backend/PetAdoptionAPI/Data/ApplicationDbContext.cs
using Microsoft.EntityFrameworkCore;
using PetAdoptionAPI.Models;

namespace PetAdoptionAPI.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
        }

        public DbSet<Animal> Animals { get; set; }  // Modelo de animales
        public DbSet<User> Users { get; set; }      // Modelo de usuarios
        public DbSet<AnimalSize> AnimalSizes { get; set; } // Modelo de tamaños de animales
        public DbSet<AnimalType> AnimalTypes {get; set; } // Modelo de tipos de animales
        public DbSet<FosterHome> FosterHomes { get; set; } // Modelo de casas de acogida
        public DbSet<AdoptionRequest> AdoptionRequests { get; set; } // Modelo de solicitudes de adopción
        public DbSet<Shelter> Shelters { get; set; } // Modelo de refugios
        public DbSet<Report> Reports { get; set; } // Modelo de reportes
        public DbSet<AnimalImage> AnimalImages { get; set; } // Modelo de imágenes de animales

    }
}

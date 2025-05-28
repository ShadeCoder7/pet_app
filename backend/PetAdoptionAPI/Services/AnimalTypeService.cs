using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using PetAdoptionAPI.Data;
using PetAdoptionAPI.Dtos;
using PetAdoptionAPI.Interfaces;

namespace PetAdoptionAPI.Services
{
    public class AnimalTypeService : IAnimalTypeService
    {
        private readonly ApplicationDbContext _context;

        public AnimalTypeService(ApplicationDbContext context)
        {
            _context = context;
        }

        // Get all animal types
        public async Task<List<AnimalTypeReadDto>> GetAllAnimalTypesAsync()
        {
            var animalTypes = await _context.AnimalTypes.ToListAsync();

            var animalTypeDtos = animalTypes.Select(at => new AnimalTypeReadDto
            {
                AnimalTypeKey = at.AnimalTypeKey,
                AnimalTypeLabel = at.AnimalTypeLabel
            }).ToList();

            return animalTypeDtos;
        }

        // Get a single animal type by key
        public async Task<AnimalTypeReadDto> GetAnimalTypeByKeyAsync(string animalTypeKey)
        {
            var at = await _context.AnimalTypes.FindAsync(animalTypeKey);
            if (at == null) return null;

            return new AnimalTypeReadDto
            {
                AnimalTypeKey = at.AnimalTypeKey,
                AnimalTypeLabel = at.AnimalTypeLabel
            };
        }
    }
}

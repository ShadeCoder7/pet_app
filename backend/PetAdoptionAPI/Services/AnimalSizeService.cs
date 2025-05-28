using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using PetAdoptionAPI.Data;
using PetAdoptionAPI.Dtos;
using PetAdoptionAPI.Interfaces;

namespace PetAdoptionAPI.Services
{
    public class AnimalSizeService : IAnimalSizeService
    {
        private readonly ApplicationDbContext _context;

        public AnimalSizeService(ApplicationDbContext context)
        {
            _context = context;
        }

        // Get all animal sizes
        public async Task<List<AnimalSizeReadDto>> GetAllAnimalSizesAsync()
        {
            var animalSizes = await _context.AnimalSizes.ToListAsync();

            var animalSizeDtos = animalSizes.Select(sz => new AnimalSizeReadDto
            {
                AnimalSizeKey = sz.AnimalSizeKey,
                AnimalSizeLabel = sz.AnimalSizeLabel,
                AnimalSizeDescription = sz.AnimalSizeDescription
            }).ToList();

            return animalSizeDtos;
        }

        // Get a single animal size by key
        public async Task<AnimalSizeReadDto> GetAnimalSizeByKeyAsync(string animalSizeKey)
        {
            var sz = await _context.AnimalSizes.FindAsync(animalSizeKey);
            if (sz == null) return null;

            return new AnimalSizeReadDto
            {
                AnimalSizeKey = sz.AnimalSizeKey,
                AnimalSizeLabel = sz.AnimalSizeLabel,
                AnimalSizeDescription = sz.AnimalSizeDescription
            };
        }
    }
}

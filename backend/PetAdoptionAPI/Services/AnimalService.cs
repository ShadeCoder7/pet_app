using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using PetAdoptionAPI.Data;
using PetAdoptionAPI.Models;
using PetAdoptionAPI.Dtos;
using PetAdoptionAPI.Interfaces;

namespace PetAdoptionAPI.Services
{
    public class AnimalService : IAnimalService
    {
        private readonly ApplicationDbContext _context;

        public AnimalService(ApplicationDbContext context)
        {
            _context = context;
        }

        // Get all animals
        public async Task<List<AnimalReadDto>> GetAllAnimalsAsync()
        {
            var animals = await _context.Animals.ToListAsync();

            var animalDtos = animals.Select(a => new AnimalReadDto
            {
                AnimalId = a.AnimalId,
                AnimalName = a.AnimalName,
                AnimalAge = a.AnimalAge,
                AnimalGender = a.AnimalGender,
                AnimalBreed = a.AnimalBreed,
                AnimalDescription = a.AnimalDescription,
                AnimalStatus = a.AnimalStatus,
                AnimalLocation = a.AnimalLocation,
                // Safe cast from decimal? (model) to double? (DTO)
                AnimalLatitude = a.AnimalLatitude.HasValue ? (double?)a.AnimalLatitude.Value : null,
                AnimalLongitude = a.AnimalLongitude.HasValue ? (double?)a.AnimalLongitude.Value : null,
                AnimalTypeKey = a.AnimalTypeKey,
                AnimalSizeKey = a.AnimalSizeKey,
                UserId = a.UserId,
                ShelterId = a.ShelterId,
                FosterHomeId = a.FosterHomeId,
                AnimalIsVerified = a.AnimalIsVerified,
                AdPostedDate = a.AdPostedDate,
                AdUpdateDate = a.AdUpdateDate,
                // The Images property is left empty for now.
                Images = new List<AnimalImageReadDto>()
            }).ToList();

            return animalDtos;
        }

        // Get a single animal by ID
        public async Task<AnimalReadDto> GetAnimalByIdAsync(Guid animalId)
        {
            var a = await _context.Animals.FindAsync(animalId);
            if (a == null) return null;

            return new AnimalReadDto
            {
                AnimalId = a.AnimalId,
                AnimalName = a.AnimalName,
                AnimalAge = a.AnimalAge,
                AnimalGender = a.AnimalGender,
                AnimalBreed = a.AnimalBreed,
                AnimalDescription = a.AnimalDescription,
                AnimalStatus = a.AnimalStatus,
                AnimalLocation = a.AnimalLocation,
                AnimalLatitude = a.AnimalLatitude.HasValue ? (double?)a.AnimalLatitude.Value : null,
                AnimalLongitude = a.AnimalLongitude.HasValue ? (double?)a.AnimalLongitude.Value : null,
                AnimalTypeKey = a.AnimalTypeKey,
                AnimalSizeKey = a.AnimalSizeKey,
                UserId = a.UserId,
                ShelterId = a.ShelterId,
                FosterHomeId = a.FosterHomeId,
                AnimalIsVerified = a.AnimalIsVerified,
                AdPostedDate = a.AdPostedDate,
                AdUpdateDate = a.AdUpdateDate,
                Images = new List<AnimalImageReadDto>()
            };
        }

        // Create a new animal
        public async Task<AnimalReadDto> CreateAnimalAsync(AnimalCreateDto dto)
        {
            var animal = new Animal
            {
                // Do not assign AnimalId manually. PostgreSQL will generate it (uuid_generate_v4()).
                AnimalName = dto.AnimalName,
                AnimalAge = dto.AnimalAge,
                AnimalGender = dto.AnimalGender,
                AnimalBreed = dto.AnimalBreed,
                AnimalDescription = dto.AnimalDescription,
                AnimalStatus = dto.AnimalStatus,
                AnimalLocation = dto.AnimalLocation,
                // Safe cast from double? (DTO) to decimal? (model)
                AnimalLatitude = dto.AnimalLatitude.HasValue ? (decimal?)dto.AnimalLatitude.Value : null,
                AnimalLongitude = dto.AnimalLongitude.HasValue ? (decimal?)dto.AnimalLongitude.Value : null,
                AnimalTypeKey = dto.AnimalTypeKey,
                AnimalSizeKey = dto.AnimalSizeKey,
                UserId = dto.UserId,
                ShelterId = dto.ShelterId,
                FosterHomeId = dto.FosterHomeId,
                AdPostedDate = DateTime.Now,
                AdUpdateDate = DateTime.Now,
                AnimalIsVerified = false // Default value
            };

            _context.Animals.Add(animal);
            await _context.SaveChangesAsync();

            return new AnimalReadDto
            {
                AnimalId = animal.AnimalId,
                AnimalName = animal.AnimalName,
                AnimalAge = animal.AnimalAge,
                AnimalGender = animal.AnimalGender,
                AnimalBreed = animal.AnimalBreed,
                AnimalDescription = animal.AnimalDescription,
                AnimalStatus = animal.AnimalStatus,
                AnimalLocation = animal.AnimalLocation,
                AnimalLatitude = animal.AnimalLatitude.HasValue ? (double?)animal.AnimalLatitude.Value : null,
                AnimalLongitude = animal.AnimalLongitude.HasValue ? (double?)animal.AnimalLongitude.Value : null,
                AnimalTypeKey = animal.AnimalTypeKey,
                AnimalSizeKey = animal.AnimalSizeKey,
                UserId = animal.UserId,
                ShelterId = animal.ShelterId,
                FosterHomeId = animal.FosterHomeId,
                AnimalIsVerified = animal.AnimalIsVerified,
                AdPostedDate = animal.AdPostedDate,
                AdUpdateDate = animal.AdUpdateDate,
                Images = new List<AnimalImageReadDto>()
            };
        }

        // Update an existing animal
        public async Task<bool> UpdateAnimalAsync(Guid animalId, AnimalUpdateDto dto)
        {
            var animal = await _context.Animals.FindAsync(animalId);
            if (animal == null) return false;

            // Only update fields that are not null in the DTO (enables partial updates)
            if (dto.AnimalName != null) animal.AnimalName = dto.AnimalName;
            if (dto.AnimalAge.HasValue) animal.AnimalAge = dto.AnimalAge;
            if (dto.AnimalGender != null) animal.AnimalGender = dto.AnimalGender;
            if (dto.AnimalBreed != null) animal.AnimalBreed = dto.AnimalBreed;
            if (dto.AnimalDescription != null) animal.AnimalDescription = dto.AnimalDescription;
            if (dto.AnimalStatus != null) animal.AnimalStatus = dto.AnimalStatus;
            if (dto.AnimalLocation != null) animal.AnimalLocation = dto.AnimalLocation;
            if (dto.AnimalLatitude.HasValue) animal.AnimalLatitude = (decimal?)dto.AnimalLatitude.Value;
            if (dto.AnimalLongitude.HasValue) animal.AnimalLongitude = (decimal?)dto.AnimalLongitude.Value;
            if (dto.AnimalTypeKey != null) animal.AnimalTypeKey = dto.AnimalTypeKey;
            if (dto.AnimalSizeKey != null) animal.AnimalSizeKey = dto.AnimalSizeKey;
            if (dto.UserId.HasValue) animal.UserId = dto.UserId;
            if (dto.ShelterId.HasValue) animal.ShelterId = dto.ShelterId;
            if (dto.FosterHomeId.HasValue) animal.FosterHomeId = dto.FosterHomeId;

            animal.AdUpdateDate = DateTime.Now;

            await _context.SaveChangesAsync();
            return true;
        }

        // Delete an animal
        public async Task<bool> DeleteAnimalAsync(Guid animalId)
        {
            var animal = await _context.Animals.FindAsync(animalId);
            if (animal == null) return false;

            _context.Animals.Remove(animal);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}

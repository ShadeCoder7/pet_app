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
            var allImages = await _context.AnimalImages.ToListAsync();

            var animalDtos = animals.Select(a =>
            {
                var images = allImages
                    .Where(img => img.AnimalId == a.AnimalId)
                    .Select(img => new AnimalImageReadDto
                    {
                        AnimalImageId = img.AnimalImageId,
                        ImageUrl = img.ImageUrl,
                        UploadDate = img.UploadDate,
                        ImageAlternativeText = img.ImageAlternativeText,
                        ImageDescription = img.ImageDescription,
                        IsMainImage = img.IsMainImage,
                        ImageIsVerified = img.ImageIsVerified,
                        AnimalId = img.AnimalId
                    })
                    .ToList();

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
                    Images = images
                };
            }).ToList();

            return animalDtos;
        }

        // Get a single animal by ID
        public async Task<AnimalReadDto> GetAnimalByIdAsync(Guid animalId)
        {
            // Get the animal by ID
            var a = await _context.Animals.FindAsync(animalId);
            if (a == null) return null;

            // Get all images for this animal
            var images = await _context.AnimalImages
                .Where(img => img.AnimalId == animalId)
                .ToListAsync();

            // Map images to DTOs
            var imageDtos = images.Select(img => new AnimalImageReadDto
            {
                AnimalImageId = img.AnimalImageId,
                ImageUrl = img.ImageUrl,
                UploadDate = img.UploadDate,
                ImageAlternativeText = img.ImageAlternativeText,
                ImageDescription = img.ImageDescription,
                IsMainImage = img.IsMainImage,
                ImageIsVerified = img.ImageIsVerified,
                AnimalId = img.AnimalId
            }).ToList();

            // Build and return the animal DTO
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
                Images = imageDtos // All images for this animal
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

            // Overwrite ALL fields directly
            animal.AnimalName = dto.AnimalName;
            animal.AnimalAge = dto.AnimalAge;
            animal.AnimalGender = dto.AnimalGender;
            animal.AnimalBreed = dto.AnimalBreed;
            animal.AnimalDescription = dto.AnimalDescription;
            animal.AnimalStatus = dto.AnimalStatus;
            animal.AnimalLocation = dto.AnimalLocation;
            animal.AnimalLatitude = dto.AnimalLatitude.HasValue ? (decimal?)dto.AnimalLatitude.Value : null;
            animal.AnimalLongitude = dto.AnimalLongitude.HasValue ? (decimal?)dto.AnimalLongitude.Value : null;
            animal.AnimalTypeKey = dto.AnimalTypeKey;
            animal.AnimalSizeKey = dto.AnimalSizeKey;
            animal.UserId = dto.UserId;
            animal.ShelterId = dto.ShelterId;
            animal.FosterHomeId = dto.FosterHomeId;

            animal.AdUpdateDate = DateTime.Now;

            await _context.SaveChangesAsync();
            return true;
        }

        // Partially update an existing animal (PATCH)
        public async Task<bool> PatchAnimalAsync(Guid animalId, AnimalPatchDto dto)
        {
            var animal = await _context.Animals.FindAsync(animalId);
            if (animal == null) return false;

            if (dto.AnimalName != null) animal.AnimalName = dto.AnimalName;
            if (dto.AnimalAge.HasValue) animal.AnimalAge = dto.AnimalAge;
            if (dto.AnimalGender != null) animal.AnimalGender = dto.AnimalGender;
            if (dto.AnimalBreed != null) animal.AnimalBreed = dto.AnimalBreed;
            if (dto.AnimalDescription != null) animal.AnimalDescription = dto.AnimalDescription;
            if (dto.AnimalStatus != null) animal.AnimalStatus = dto.AnimalStatus;
            if (dto.AnimalLocation != null) animal.AnimalLocation = dto.AnimalLocation;
            if (dto.AnimalLatitude.HasValue) animal.AnimalLatitude = (decimal?)dto.AnimalLatitude;
            if (dto.AnimalLongitude.HasValue) animal.AnimalLongitude = (decimal?)dto.AnimalLongitude;
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

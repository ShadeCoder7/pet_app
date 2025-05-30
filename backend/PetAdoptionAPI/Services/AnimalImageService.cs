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
    public class AnimalImageService : IAnimalImageService
    {
        private readonly ApplicationDbContext _context;

        public AnimalImageService(ApplicationDbContext context)
        {
            _context = context;
        }

        // Get all animal images
        public async Task<List<AnimalImageReadDto>> GetAllAnimalImagesAsync()
        {
            var images = await _context.AnimalImages.ToListAsync();
            return images.Select(MapToReadDto).ToList();
        }

        // Get all images for a specific animal
        public async Task<List<AnimalImageReadDto>> GetImagesByAnimalIdAsync(Guid animalId)
        {
            var images = await _context.AnimalImages
                .Where(img => img.AnimalId == animalId)
                .ToListAsync();
            return images.Select(MapToReadDto).ToList();
        }

        // Get a single animal image by its ID
        public async Task<AnimalImageReadDto> GetAnimalImageByIdAsync(int animalImageId)
        {
            var image = await _context.AnimalImages.FindAsync(animalImageId);
            return image == null ? null : MapToReadDto(image);
        }

        // Create a new animal image
        public async Task<AnimalImageReadDto> CreateAnimalImageAsync(AnimalImageCreateDto dto)
        {
            var image = new AnimalImage
            {
                ImageUrl = dto.ImageUrl,
                ImageAlternativeText = dto.ImageAlternativeText,
                ImageDescription = dto.ImageDescription,
                IsMainImage = dto.IsMainImage ?? false,
                ImageIsVerified = false, // Default to false, admin must verify
                AnimalId = dto.AnimalId,
                UploadDate = DateTime.UtcNow
            };

            _context.AnimalImages.Add(image);
            await _context.SaveChangesAsync();

            return MapToReadDto(image);
        }

        // Update an existing animal image
        public async Task<bool> UpdateAnimalImageAsync(int animalImageId, AnimalImageUpdateDto dto)
        {
            var image = await _context.AnimalImages.FindAsync(animalImageId);
            if (image == null) return false;

            // Update fields if provided in the DTO (partial update)
            if (dto.ImageUrl != null) image.ImageUrl = dto.ImageUrl;
            if (dto.ImageAlternativeText != null) image.ImageAlternativeText = dto.ImageAlternativeText;
            if (dto.ImageDescription != null) image.ImageDescription = dto.ImageDescription;
            if (dto.IsMainImage.HasValue) image.IsMainImage = dto.IsMainImage.Value;
            if (dto.ImageIsVerified.HasValue) image.ImageIsVerified = dto.ImageIsVerified.Value;

            await _context.SaveChangesAsync();
            return true;
        }

        // Delete an animal image
        public async Task<bool> DeleteAnimalImageAsync(int animalImageId)
        {
            var image = await _context.AnimalImages.FindAsync(animalImageId);
            if (image == null) return false;

            _context.AnimalImages.Remove(image);
            await _context.SaveChangesAsync();
            return true;
        }

        // Private helper to map model to read DTO
        private AnimalImageReadDto MapToReadDto(AnimalImage image)
        {
            return new AnimalImageReadDto
            {
                AnimalImageId = image.AnimalImageId,
                ImageUrl = image.ImageUrl,
                UploadDate = image.UploadDate,
                ImageAlternativeText = image.ImageAlternativeText,
                ImageDescription = image.ImageDescription,
                IsMainImage = image.IsMainImage,
                ImageIsVerified = image.ImageIsVerified,
                AnimalId = image.AnimalId
            };
        }
    }
}

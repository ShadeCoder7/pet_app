using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using PetAdoptionAPI.Dtos;

namespace PetAdoptionAPI.Interfaces
{
    public interface IAnimalImageService
    {
        Task<List<AnimalImageReadDto>> GetAllImagesAsync();
        Task<List<AnimalImageReadDto>> GetImagesByAnimalIdAsync(Guid animalId);
        Task<AnimalImageReadDto> GetImageByIdAsync(int animalImageId);
        Task<AnimalImageReadDto> CreateImageAsync(AnimalImageCreateDto animalImageCreateDto);
        Task<bool> UpdateImageAsync(int animalImageId, AnimalImageUpdateDto animalImageUpdateDto);
        Task<bool> DeleteImageAsync(int animalImageId);
    }
}

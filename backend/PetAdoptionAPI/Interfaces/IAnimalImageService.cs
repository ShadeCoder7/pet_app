using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using PetAdoptionAPI.Dtos;

namespace PetAdoptionAPI.Interfaces
{
    public interface IAnimalImageService
    {
        Task<List<AnimalImageReadDto>> GetAllAnimalImagesAsync();
        Task<List<AnimalImageReadDto>> GetImagesByAnimalIdAsync(Guid animalId);
        Task<AnimalImageReadDto> GetAnimalImageByIdAsync(int animalImageId);
        Task<AnimalImageReadDto> CreateAnimalImageAsync(AnimalImageCreateDto animalImageCreateDto);
        Task<bool> UpdateAnimalImageAsync(int animalImageId, AnimalImageUpdateDto animalImageUpdateDto);
        Task<bool> DeleteAnimalImageAsync(int animalImageId);
    }
}

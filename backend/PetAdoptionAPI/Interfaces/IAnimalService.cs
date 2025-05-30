// Interfaces/IAnimalService.cs
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using PetAdoptionAPI.Dtos;

namespace PetAdoptionAPI.Interfaces
{
    public interface IAnimalService
    {
        Task<List<AnimalReadDto>> GetAllAnimalsAsync();
        Task<AnimalReadDto> GetAnimalByIdAsync(Guid animalId);
        Task<AnimalReadDto> CreateAnimalAsync(AnimalCreateDto animalCreateDto);
        Task<bool> UpdateAnimalAsync(Guid animalId, AnimalUpdateDto animalUpdateDto);
        Task<bool> PatchAnimalAsync(Guid animalId, AnimalPatchDto patchDto);
        Task<bool> DeleteAnimalAsync(Guid animalId);
    }
}

using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using PetAdoptionAPI.Dtos;

namespace PetAdoptionAPI.Interfaces
{
    public interface IShelterService
    {
        Task<List<ShelterReadDto>> GetAllSheltersAsync();
        Task<ShelterReadDto> GetShelterByIdAsync(Guid shelterId);
        Task<List<ShelterReadDto>> GetSheltersByNameAsync(string name);
        Task<ShelterReadDto> CreateShelterAsync(ShelterCreateDto shelterCreateDto);
        Task<bool> UpdateShelterAsync(Guid shelterId, ShelterUpdateDto shelterUpdateDto);
        Task<bool> DeleteShelterAsync(Guid shelterId);
    }
}

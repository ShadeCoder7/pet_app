using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using PetAdoptionAPI.Dtos;

namespace PetAdoptionAPI.Interfaces
{
    public interface IAdoptionRequestService
    {
        Task<List<AdoptionRequestReadDto>> GetAllAdoptionRequestsAsync();
        Task<AdoptionRequestReadDto> GetAdoptionRequestByIdAsync(Guid adoptionRequestId);
        Task<AdoptionRequestReadDto> CreateAdoptionRequestAsync(AdoptionRequestCreateDto adoptionRequestCreateDto);
        Task<bool> UpdateAdoptionRequestAsync(Guid adoptionRequestId, AdoptionRequestUpdateDto adoptionRequestUpdateDto);
        Task<bool> DeleteAdoptionRequestAsync(Guid adoptionRequestId);
        Task<List<AdoptionRequestReadDto>> GetAdoptionRequestsByUserIdAsync(Guid userId);
        Task<List<AdoptionRequestReadDto>> GetAdoptionRequestsByAnimalIdAsync(Guid animalId);
    }
}

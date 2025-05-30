using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using PetAdoptionAPI.Dtos;

namespace PetAdoptionAPI.Interfaces
{
    public interface IFosterHomeService
    {
        Task<List<FosterHomeReadDto>> GetAllFosterHomesAsync();
        Task<FosterHomeReadDto> GetFosterHomeByIdAsync(Guid fosterHomeId);
        Task<List<FosterHomeReadDto>> GetFosterHomesByNameAsync(string name);
        Task<FosterHomeReadDto> CreateFosterHomeAsync(FosterHomeCreateDto fosterHomeCreateDto);
        Task<bool> UpdateFosterHomeAsync(Guid fosterHomeId, FosterHomeUpdateDto fosterHomeUpdateDto);
        Task<bool> DeleteFosterHomeAsync(Guid fosterHomeId);
    }
}

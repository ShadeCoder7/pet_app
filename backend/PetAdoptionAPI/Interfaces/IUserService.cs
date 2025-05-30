using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using PetAdoptionAPI.Dtos;

namespace PetAdoptionAPI.Interfaces
{
    public interface IUserService
    {
        Task<List<UserReadDto>> GetAllUsersAsync();
        Task<UserReadDto> GetUserByIdAsync(Guid userId);
        Task<UserReadDto> CreateUserAsync(UserCreateDto userCreateDto);
        Task<bool> UpdateUserAsync(Guid userId, UserUpdateDto userUpdateDto);
        Task<bool> PatchUserAsync(Guid userId, UserPatchDto userPatchDto);
        Task<bool> DeleteUserAsync(Guid userId);
    }
}

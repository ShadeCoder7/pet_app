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
    public class UserService : IUserService
    {
        private readonly ApplicationDbContext _context;

        public UserService(ApplicationDbContext context)
        {
            _context = context;
        }

        // Get all users
        public async Task<List<UserReadDto>> GetAllUsersAsync()
        {
            var users = await _context.Users.ToListAsync();

            var userDtos = users.Select(u => new UserReadDto
            {
                UserId = u.UserId,
                UserEmail = u.UserEmail,
                UserRole = u.UserRole,
                IsRoleVerified = u.IsRoleVerified,
                UserFirstName = u.UserFirstName,
                UserLastName = u.UserLastName,
                UserPhoneNumber = u.UserPhoneNumber,
                UserAddress = u.UserAddress,
                CreateUserDate = u.CreateUserDate,
                UserBirthDate = u.UserBirthDate,
                UserProfilePicture = u.UserProfilePicture,
                UserIsVerified = u.UserIsVerified
            }).ToList();

            return userDtos;
        }

        // Get a user by ID
        public async Task<UserReadDto> GetUserByIdAsync(Guid userId)
        {
            var user = await _context.Users.FindAsync(userId);
            if (user == null) return null;

            return new UserReadDto
            {
                UserId = user.UserId,
                UserEmail = user.UserEmail,
                UserRole = user.UserRole,
                IsRoleVerified = user.IsRoleVerified,
                UserFirstName = user.UserFirstName,
                UserLastName = user.UserLastName,
                UserPhoneNumber = user.UserPhoneNumber,
                UserAddress = user.UserAddress,
                CreateUserDate = user.CreateUserDate,
                UserBirthDate = user.UserBirthDate,
                UserProfilePicture = user.UserProfilePicture,
                UserIsVerified = user.UserIsVerified
            };
        }

        // Create a new user
        public async Task<UserReadDto> CreateUserAsync(UserCreateDto dto)
        {
            var user = new User
            {
                // UserId is generated automatically by PostgreSQL (uuid_generate_v4()).
                UserEmail = dto.UserEmail,
                UserRole = dto.UserRole,
                IsRoleVerified = false, // Default, to be updated by admin if needed
                UserFirstName = dto.UserFirstName,
                UserLastName = dto.UserLastName,
                UserPhoneNumber = dto.UserPhoneNumber,
                UserAddress = dto.UserAddress,
                CreateUserDate = DateTime.UtcNow,
                UserBirthDate = dto.UserBirthDate,
                UserProfilePicture = dto.UserProfilePicture,
                UserIsVerified = false // Default, to be updated after verification
            };

            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            return new UserReadDto
            {
                UserId = user.UserId,
                UserEmail = user.UserEmail,
                UserRole = user.UserRole,
                IsRoleVerified = user.IsRoleVerified,
                UserFirstName = user.UserFirstName,
                UserLastName = user.UserLastName,
                UserPhoneNumber = user.UserPhoneNumber,
                UserAddress = user.UserAddress,
                CreateUserDate = user.CreateUserDate,
                UserBirthDate = user.UserBirthDate,
                UserProfilePicture = user.UserProfilePicture,
                UserIsVerified = user.UserIsVerified
            };
        }

        // Update a user
        public async Task<bool> UpdateUserAsync(Guid userId, UserUpdateDto dto)
        {
            var user = await _context.Users.FindAsync(userId);
            if (user == null) return false;

            // Only update fields if they are not null (enables partial updates)
            if (dto.UserFirstName != null) user.UserFirstName = dto.UserFirstName;
            if (dto.UserLastName != null) user.UserLastName = dto.UserLastName;
            if (dto.UserPhoneNumber != null) user.UserPhoneNumber = dto.UserPhoneNumber;
            if (dto.UserAddress != null) user.UserAddress = dto.UserAddress;
            if (dto.UserBirthDate != DateTime.MinValue) user.UserBirthDate = dto.UserBirthDate;
            if (dto.UserProfilePicture != null) user.UserProfilePicture = dto.UserProfilePicture;
            if (dto.UserRole != null) user.UserRole = dto.UserRole;
            if (dto.IsRoleVerified.HasValue) user.IsRoleVerified = dto.IsRoleVerified.Value;
            if (dto.UserIsVerified.HasValue) user.UserIsVerified = dto.UserIsVerified.Value;

            await _context.SaveChangesAsync();
            return true;
        }

        // Partial user updates (PATCH)
        public async Task<bool> PatchUserAsync(Guid userId, UserPatchDto dto)
        {
            var user = await _context.Users.FindAsync(userId);
            if (user == null) return false;

            // Only update fields that are provided (not null)
            if (dto.UserFirstName != null) user.UserFirstName = dto.UserFirstName;
            if (dto.UserLastName != null) user.UserLastName = dto.UserLastName;
            if (dto.UserPhoneNumber != null) user.UserPhoneNumber = dto.UserPhoneNumber;
            if (dto.UserAddress != null) user.UserAddress = dto.UserAddress;
            if (dto.UserBirthDate.HasValue) user.UserBirthDate = dto.UserBirthDate.Value;
            if (dto.UserProfilePicture != null) user.UserProfilePicture = dto.UserProfilePicture;
            if (dto.UserRole != null) user.UserRole = dto.UserRole;
            if (dto.IsRoleVerified.HasValue) user.IsRoleVerified = dto.IsRoleVerified.Value;
            if (dto.UserIsVerified.HasValue) user.UserIsVerified = dto.UserIsVerified.Value;

            await _context.SaveChangesAsync();
            return true;
        }


        // Delete a user
        public async Task<bool> DeleteUserAsync(Guid userId)
        {
            var user = await _context.Users.FindAsync(userId);
            if (user == null) return false;

            _context.Users.Remove(user);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}

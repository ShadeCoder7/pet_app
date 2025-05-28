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
    public class FosterHomeService : IFosterHomeService
    {
        private readonly ApplicationDbContext _context;

        public FosterHomeService(ApplicationDbContext context)
        {
            _context = context;
        }

        // Get all foster homes
        public async Task<List<FosterHomeReadDto>> GetAllFosterHomesAsync()
        {
            var fosterHomes = await _context.FosterHomes.ToListAsync();

            var fosterHomeDtos = fosterHomes.Select(fh => new FosterHomeReadDto
            {
                FosterHomeId = fh.FosterHomeId,
                FosterHomeName = fh.FosterHomeName,
                FosterHomeDescription = fh.FosterHomeDescription,
                FosterHomeCapacity = fh.FosterHomeCapacity,
                FosterHomeCurrentCapacity = fh.FosterHomeCurrentCapacity,
                FosterHomeCurrentOccupancy = fh.FosterHomeCurrentOccupancy,
                FosterHomeWebsite = fh.FosterHomeWebsite,
                FosterHomeAddress = fh.FosterHomeAddress,
                FosterHomePhoneNumber = fh.FosterHomePhoneNumber,
                FosterHomeCreateDate = fh.FosterHomeCreateDate,
                FosterHomeUpdateDate = fh.FosterHomeUpdateDate,
                FosterHomeIsVerified = fh.FosterHomeIsVerified,
                UserId = fh.UserId
            }).ToList();

            return fosterHomeDtos;
        }

        // Get a foster home by ID
        public async Task<FosterHomeReadDto> GetFosterHomeByIdAsync(Guid fosterHomeId)
        {
            var fh = await _context.FosterHomes.FindAsync(fosterHomeId);
            if (fh == null) return null;

            return new FosterHomeReadDto
            {
                FosterHomeId = fh.FosterHomeId,
                FosterHomeName = fh.FosterHomeName,
                FosterHomeDescription = fh.FosterHomeDescription,
                FosterHomeCapacity = fh.FosterHomeCapacity,
                FosterHomeCurrentCapacity = fh.FosterHomeCurrentCapacity,
                FosterHomeCurrentOccupancy = fh.FosterHomeCurrentOccupancy,
                FosterHomeWebsite = fh.FosterHomeWebsite,
                FosterHomeAddress = fh.FosterHomeAddress,
                FosterHomePhoneNumber = fh.FosterHomePhoneNumber,
                FosterHomeCreateDate = fh.FosterHomeCreateDate,
                FosterHomeUpdateDate = fh.FosterHomeUpdateDate,
                FosterHomeIsVerified = fh.FosterHomeIsVerified,
                UserId = fh.UserId
            };
        }

        // Create a new foster home
        public async Task<FosterHomeReadDto> CreateFosterHomeAsync(FosterHomeCreateDto dto)
        {
            var fosterHome = new FosterHome
            {
                // FosterHomeId is generated automatically by PostgreSQL (uuid_generate_v4()).
                FosterHomeName = dto.FosterHomeName,
                FosterHomeDescription = dto.FosterHomeDescription,
                FosterHomeCapacity = dto.FosterHomeCapacity,
                FosterHomeCurrentCapacity = 0, // Default value for a new foster home
                FosterHomeCurrentOccupancy = 0, // Default value for a new foster home
                FosterHomeWebsite = dto.FosterHomeWebsite,
                FosterHomeAddress = dto.FosterHomeAddress,
                FosterHomePhoneNumber = dto.FosterHomePhoneNumber,
                FosterHomeCreateDate = DateTime.UtcNow,
                FosterHomeUpdateDate = DateTime.UtcNow,
                FosterHomeIsVerified = false,
                UserId = dto.UserId
            };

            _context.FosterHomes.Add(fosterHome);
            await _context.SaveChangesAsync();

            return new FosterHomeReadDto
            {
                FosterHomeId = fosterHome.FosterHomeId,
                FosterHomeName = fosterHome.FosterHomeName,
                FosterHomeDescription = fosterHome.FosterHomeDescription,
                FosterHomeCapacity = fosterHome.FosterHomeCapacity,
                FosterHomeCurrentCapacity = fosterHome.FosterHomeCurrentCapacity,
                FosterHomeCurrentOccupancy = fosterHome.FosterHomeCurrentOccupancy,
                FosterHomeWebsite = fosterHome.FosterHomeWebsite,
                FosterHomeAddress = fosterHome.FosterHomeAddress,
                FosterHomePhoneNumber = fosterHome.FosterHomePhoneNumber,
                FosterHomeCreateDate = fosterHome.FosterHomeCreateDate,
                FosterHomeUpdateDate = fosterHome.FosterHomeUpdateDate,
                FosterHomeIsVerified = fosterHome.FosterHomeIsVerified,
                UserId = fosterHome.UserId
            };
        }

        // Update a foster home
        public async Task<bool> UpdateFosterHomeAsync(Guid fosterHomeId, FosterHomeUpdateDto dto)
        {
            var fosterHome = await _context.FosterHomes.FindAsync(fosterHomeId);
            if (fosterHome == null) return false;

            // Only update fields if they are not null (partial update)
            if (dto.FosterHomeName != null) fosterHome.FosterHomeName = dto.FosterHomeName;
            if (dto.FosterHomeDescription != null) fosterHome.FosterHomeDescription = dto.FosterHomeDescription;
            if (dto.FosterHomeCapacity.HasValue) fosterHome.FosterHomeCapacity = dto.FosterHomeCapacity.Value;
            if (dto.FosterHomeWebsite != null) fosterHome.FosterHomeWebsite = dto.FosterHomeWebsite;
            if (dto.FosterHomeAddress != null) fosterHome.FosterHomeAddress = dto.FosterHomeAddress;
            if (dto.FosterHomePhoneNumber != null) fosterHome.FosterHomePhoneNumber = dto.FosterHomePhoneNumber;
            if (dto.UserId.HasValue) fosterHome.UserId = dto.UserId;
            if (dto.FosterHomeIsVerified.HasValue) fosterHome.FosterHomeIsVerified = dto.FosterHomeIsVerified.Value;

            fosterHome.FosterHomeUpdateDate = DateTime.UtcNow;

            await _context.SaveChangesAsync();
            return true;
        }

        // Delete a foster home
        public async Task<bool> DeleteFosterHomeAsync(Guid fosterHomeId)
        {
            var fosterHome = await _context.FosterHomes.FindAsync(fosterHomeId);
            if (fosterHome == null) return false;

            _context.FosterHomes.Remove(fosterHome);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}

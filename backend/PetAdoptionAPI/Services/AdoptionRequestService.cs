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
    public class AdoptionRequestService : IAdoptionRequestService
    {
        private readonly ApplicationDbContext _context;

        public AdoptionRequestService(ApplicationDbContext context)
        {
            _context = context;
        }

        // Get all adoption requests
        public async Task<List<AdoptionRequestReadDto>> GetAllAdoptionRequestsAsync()
        {
            var requests = await _context.AdoptionRequests.ToListAsync();
            return requests.Select(MapToReadDto).ToList();
        }

        // Get a single adoption request by ID
        public async Task<AdoptionRequestReadDto> GetAdoptionRequestByIdAsync(Guid adoptionRequestId)
        {
            var request = await _context.AdoptionRequests.FindAsync(adoptionRequestId);
            return request == null ? null : MapToReadDto(request);
        }

        // Get adoption requests by user ID
        public async Task<List<AdoptionRequestReadDto>> GetAdoptionRequestsByUserIdAsync(Guid userId)
        {
            var requests = await _context.AdoptionRequests
                .Where(r => r.UserId == userId)
                .ToListAsync();
            return requests.Select(MapToReadDto).ToList();
        }

        // Get adoption requests by animal ID
        public async Task<List<AdoptionRequestReadDto>> GetAdoptionRequestsByAnimalIdAsync(Guid animalId)
        {
            var requests = await _context.AdoptionRequests
                .Where(r => r.AnimalId == animalId)
                .ToListAsync();
            return requests.Select(MapToReadDto).ToList();
        }

        // Create a new adoption request
        public async Task<AdoptionRequestReadDto> CreateAdoptionRequestAsync(AdoptionRequestCreateDto dto)
        {
            var request = new AdoptionRequest
            {
                // AdoptionRequestId is generated automatically by PostgreSQL (uuid_generate_v4()).
                RequestStatus = "pending", // Default status
                RequestMessage = dto.RequestMessage,
                RequestDate = DateTime.UtcNow,
                RequestUpdateDate = DateTime.UtcNow,
                RequestIsVerified = false,
                RequestIsCompleted = false,
                UserId = dto.UserId,
                AnimalId = dto.AnimalId
            };

            _context.AdoptionRequests.Add(request);
            await _context.SaveChangesAsync();

            return MapToReadDto(request);
        }

        // Update an adoption request
        public async Task<bool> UpdateAdoptionRequestAsync(Guid adoptionRequestId, AdoptionRequestUpdateDto dto)
        {
            var request = await _context.AdoptionRequests.FindAsync(adoptionRequestId);
            if (request == null) return false;

            // Partial update: only update provided fields
            if (dto.RequestStatus != null) request.RequestStatus = dto.RequestStatus;
            if (dto.RequestResponse != null) request.RequestResponse = dto.RequestResponse;
            if (dto.RequestResponseDate.HasValue) request.RequestResponseDate = dto.RequestResponseDate;
            if (dto.RequestIsVerified.HasValue) request.RequestIsVerified = dto.RequestIsVerified.Value;
            if (dto.RequestIsCompleted.HasValue) request.RequestIsCompleted = dto.RequestIsCompleted.Value;

            request.RequestUpdateDate = DateTime.UtcNow;

            await _context.SaveChangesAsync();
            return true;
        }

        // Delete an adoption request
        public async Task<bool> DeleteAdoptionRequestAsync(Guid adoptionRequestId)
        {
            var request = await _context.AdoptionRequests.FindAsync(adoptionRequestId);
            if (request == null) return false;

            _context.AdoptionRequests.Remove(request);
            await _context.SaveChangesAsync();
            return true;
        }

        // Private helper to map model to read DTO
        private AdoptionRequestReadDto MapToReadDto(AdoptionRequest r)
        {
            return new AdoptionRequestReadDto
            {
                AdoptionRequestId = r.AdoptionRequestId,
                RequestDate = r.RequestDate,
                RequestUpdateDate = r.RequestUpdateDate,
                RequestStatus = r.RequestStatus,
                RequestMessage = r.RequestMessage,
                RequestResponse = r.RequestResponse,
                RequestResponseDate = r.RequestResponseDate,
                RequestIsVerified = r.RequestIsVerified,
                RequestIsCompleted = r.RequestIsCompleted,
                UserId = r.UserId,
                AnimalId = r.AnimalId
            };
        }
    }
}

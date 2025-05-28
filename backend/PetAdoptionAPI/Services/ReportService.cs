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
    public class ReportService : IReportService
    {
        private readonly ApplicationDbContext _context;

        public ReportService(ApplicationDbContext context)
        {
            _context = context;
        }

        // Get all reports
        public async Task<List<ReportReadDto>> GetAllReportsAsync()
        {
            var reports = await _context.Reports.ToListAsync();

            var reportDtos = reports.Select(r => new ReportReadDto
            {
                ReportId = r.ReportId,
                ReportTitle = r.ReportTitle,
                ReportType = r.ReportType,
                ReportDescription = r.ReportDescription,
                ReportDate = r.ReportDate,
                ReportUpdateDate = r.ReportUpdateDate,
                ReportImageUrl = r.ReportImageUrl,
                ReportStatus = r.ReportStatus,
                ReportAddress = r.ReportAddress,
                ReportCity = r.ReportCity,
                ReportProvince = r.ReportProvince,
                ReportPostalCode = r.ReportPostalCode,
                ReportCountry = r.ReportCountry,
                ReportLatitude = r.ReportLatitude,
                ReportLongitude = r.ReportLongitude,
                ReportIsVerified = r.ReportIsVerified,
                AnimalName = r.AnimalName,
                AnimalGender = r.AnimalGender,
                AnimalBreed = r.AnimalBreed,
                LastSeenDate = r.LastSeenDate,
                UserId = r.UserId,
                AnimalTypeKey = r.AnimalTypeKey,
                AnimalSizeKey = r.AnimalSizeKey
            }).ToList();

            return reportDtos;
        }

        // Get a single report by ID
        public async Task<ReportReadDto> GetReportByIdAsync(Guid reportId)
        {
            var r = await _context.Reports.FindAsync(reportId);
            if (r == null) return null;

            return new ReportReadDto
            {
                ReportId = r.ReportId,
                ReportTitle = r.ReportTitle,
                ReportType = r.ReportType,
                ReportDescription = r.ReportDescription,
                ReportDate = r.ReportDate,
                ReportUpdateDate = r.ReportUpdateDate,
                ReportImageUrl = r.ReportImageUrl,
                ReportStatus = r.ReportStatus,
                ReportAddress = r.ReportAddress,
                ReportCity = r.ReportCity,
                ReportProvince = r.ReportProvince,
                ReportPostalCode = r.ReportPostalCode,
                ReportCountry = r.ReportCountry,
                ReportLatitude = r.ReportLatitude,
                ReportLongitude = r.ReportLongitude,
                ReportIsVerified = r.ReportIsVerified,
                AnimalName = r.AnimalName,
                AnimalGender = r.AnimalGender,
                AnimalBreed = r.AnimalBreed,
                LastSeenDate = r.LastSeenDate,
                UserId = r.UserId,
                AnimalTypeKey = r.AnimalTypeKey,
                AnimalSizeKey = r.AnimalSizeKey
            };
        }

        // Create a new report
        public async Task<ReportReadDto> CreateReportAsync(ReportCreateDto dto)
        {
            var report = new Report
            {
                // ReportId is generated automatically by PostgreSQL (uuid_generate_v4()).
                ReportTitle = dto.ReportTitle,
                ReportType = dto.ReportType,
                ReportDescription = dto.ReportDescription,
                ReportDate = DateTime.UtcNow,
                ReportUpdateDate = DateTime.UtcNow,
                ReportImageUrl = dto.ReportImageUrl,
                ReportStatus = string.IsNullOrEmpty(dto.ReportStatus) ? "pending" : dto.ReportStatus,
                ReportAddress = dto.ReportAddress,
                ReportCity = dto.ReportCity,
                ReportProvince = dto.ReportProvince,
                ReportPostalCode = dto.ReportPostalCode,
                ReportCountry = dto.ReportCountry,
                ReportLatitude = dto.ReportLatitude,
                ReportLongitude = dto.ReportLongitude,
                ReportIsVerified = false,
                AnimalName = dto.AnimalName,
                AnimalGender = dto.AnimalGender,
                AnimalBreed = dto.AnimalBreed,
                LastSeenDate = dto.LastSeenDate,
                UserId = dto.UserId,
                AnimalTypeKey = dto.AnimalTypeKey,
                AnimalSizeKey = dto.AnimalSizeKey
            };

            _context.Reports.Add(report);
            await _context.SaveChangesAsync();

            return new ReportReadDto
            {
                ReportId = report.ReportId,
                ReportTitle = report.ReportTitle,
                ReportType = report.ReportType,
                ReportDescription = report.ReportDescription,
                ReportDate = report.ReportDate,
                ReportUpdateDate = report.ReportUpdateDate,
                ReportImageUrl = report.ReportImageUrl,
                ReportStatus = report.ReportStatus,
                ReportAddress = report.ReportAddress,
                ReportCity = report.ReportCity,
                ReportProvince = report.ReportProvince,
                ReportPostalCode = report.ReportPostalCode,
                ReportCountry = report.ReportCountry,
                ReportLatitude = report.ReportLatitude,
                ReportLongitude = report.ReportLongitude,
                ReportIsVerified = report.ReportIsVerified,
                AnimalName = report.AnimalName,
                AnimalGender = report.AnimalGender,
                AnimalBreed = report.AnimalBreed,
                LastSeenDate = report.LastSeenDate,
                UserId = report.UserId,
                AnimalTypeKey = report.AnimalTypeKey,
                AnimalSizeKey = report.AnimalSizeKey
            };
        }

        // Update an existing report
        public async Task<bool> UpdateReportAsync(Guid reportId, ReportUpdateDto dto)
        {
            var report = await _context.Reports.FindAsync(reportId);
            if (report == null) return false;

            // Only update fields that are not null in the DTO (enables partial updates)
            if (dto.ReportTitle != null) report.ReportTitle = dto.ReportTitle;
            if (dto.ReportType != null) report.ReportType = dto.ReportType;
            if (dto.ReportDescription != null) report.ReportDescription = dto.ReportDescription;
            if (dto.ReportImageUrl != null) report.ReportImageUrl = dto.ReportImageUrl;
            if (dto.ReportStatus != null) report.ReportStatus = dto.ReportStatus;
            if (dto.ReportAddress != null) report.ReportAddress = dto.ReportAddress;
            if (dto.ReportCity != null) report.ReportCity = dto.ReportCity;
            if (dto.ReportProvince != null) report.ReportProvince = dto.ReportProvince;
            if (dto.ReportPostalCode != null) report.ReportPostalCode = dto.ReportPostalCode;
            if (dto.ReportCountry != null) report.ReportCountry = dto.ReportCountry;
            if (dto.ReportLatitude.HasValue) report.ReportLatitude = dto.ReportLatitude;
            if (dto.ReportLongitude.HasValue) report.ReportLongitude = dto.ReportLongitude;
            if (dto.AnimalName != null) report.AnimalName = dto.AnimalName;
            if (dto.AnimalGender != null) report.AnimalGender = dto.AnimalGender;
            if (dto.AnimalBreed != null) report.AnimalBreed = dto.AnimalBreed;
            if (dto.LastSeenDate.HasValue) report.LastSeenDate = dto.LastSeenDate;
            if (dto.AnimalTypeKey != null) report.AnimalTypeKey = dto.AnimalTypeKey;
            if (dto.AnimalSizeKey != null) report.AnimalSizeKey = dto.AnimalSizeKey;
            if (dto.ReportIsVerified.HasValue) report.ReportIsVerified = dto.ReportIsVerified.Value;

            report.ReportUpdateDate = DateTime.UtcNow;

            await _context.SaveChangesAsync();
            return true;
        }

        // Delete a report
        public async Task<bool> DeleteReportAsync(Guid reportId)
        {
            var report = await _context.Reports.FindAsync(reportId);
            if (report == null) return false;

            _context.Reports.Remove(report);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}

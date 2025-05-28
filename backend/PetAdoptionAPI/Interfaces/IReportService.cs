using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using PetAdoptionAPI.Dtos;

namespace PetAdoptionAPI.Interfaces
{
    public interface IReportService
    {
        Task<List<ReportReadDto>> GetAllReportsAsync();
        Task<ReportReadDto> GetReportByIdAsync(Guid reportId);
        Task<ReportReadDto> CreateReportAsync(ReportCreateDto reportCreateDto);
        Task<bool> UpdateReportAsync(Guid reportId, ReportUpdateDto reportUpdateDto);
        Task<bool> DeleteReportAsync(Guid reportId);
    }
}

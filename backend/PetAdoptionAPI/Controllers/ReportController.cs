using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;
using PetAdoptionAPI.Interfaces;   // For IReportService
using PetAdoptionAPI.Dtos;         // For DTOs

namespace PetAdoptionAPI.Controllers
{
    [ApiController] // Marks this class as an API Controller
    [Route("api/[controller]")] // Base route will be api/report
    public class ReportController : ControllerBase
    {
        private readonly IReportService _reportService;

        // Constructor with dependency injection of the service
        public ReportController(IReportService reportService)
        {
            _reportService = reportService;
        }

        // GET: api/report
        /// <summary>
        /// Retrieves a list of all reports.
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> GetAllReports()
        {
            var reports = await _reportService.GetAllReportsAsync();
            return Ok(reports); // Returns 200 OK with the list of reports
        }

        // GET: api/report/{id}
        /// <summary>
        /// Retrieves a specific report by its unique ID.
        /// </summary>
        [HttpGet("{id}")]
        public async Task<IActionResult> GetReportById(Guid id)
        {
            var report = await _reportService.GetReportByIdAsync(id);
            if (report == null)
                return NotFound(); // Returns 404 if the report does not exist
            return Ok(report);
        }

        // POST: api/report
        /// <summary>
        /// Creates a new report.
        /// </summary>
        [HttpPost]
        public async Task<IActionResult> CreateReport([FromBody] ReportCreateDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState); // Returns 400 if the model is invalid

            var createdReport = await _reportService.CreateReportAsync(dto);
            // Returns 201 Created with the URI of the new resource
            return CreatedAtAction(nameof(GetReportById), new { id = createdReport.ReportId }, createdReport);
        }

        // PUT: api/report/{id}
        /// <summary>
        /// Updates an existing report by ID.
        /// </summary>
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateReport(Guid id, [FromBody] ReportUpdateDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState); // Returns 400 if the model is invalid

            var success = await _reportService.UpdateReportAsync(id, dto);
            if (!success)
                return NotFound(); // Returns 404 if the report does not exist

            return NoContent(); // Returns 204 No Content on success
        }

        // DELETE: api/report/{id}
        /// <summary>
        /// Deletes a report by its ID.
        /// </summary>
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteReport(Guid id)
        {
            var success = await _reportService.DeleteReportAsync(id);
            if (!success)
                return NotFound(); // Returns 404 if the report does not exist

            return NoContent(); // Returns 204 No Content on successful deletion
        }
    }
}

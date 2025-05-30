using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;
using PetAdoptionAPI.Interfaces;   // For IUserService
using PetAdoptionAPI.Dtos;         // For DTOs

namespace PetAdoptionAPI.Controllers
{
    [ApiController] // Marks this class as an API Controller
    [Route("api/[controller]")]
    public class AdoptionRequestController : ControllerBase
    {
        private readonly IAdoptionRequestService _adoptionrequestService;

        // Constructor with dependency injection of the service
        public AdoptionRequestController(IAdoptionRequestService adoptionrequestService)
        {
            _adoptionrequestService = adoptionrequestService;
        }

        // GET: api/adoptionrequest
        /// <summary>
        /// Retrieves a list of all adoption requests.
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> GetAllAdoptionRequest()
        {
            var adoptionrequests = await _adoptionrequestService.GetAllAdoptionRequestsAsync();
            return Ok(adoptionrequests); // Returns 200 OK with the list of users
        }

        // GET: api/adoptionrequest/{id}
        /// <summary>
        /// Retrieves a specific adoption request by their unique ID.
        /// </summary>
        [HttpGet("{id}")]
        public async Task<IActionResult> GetAdoptionRequestById(Guid id)
        {
            var adoptionrequest = await _adoptionrequestService.GetAdoptionRequestByIdAsync(id);
            if (adoptionrequest == null)
                return NotFound(); // Returns 404 if the user does not exist
            return Ok(adoptionrequest);
        }

        // POST: api/adoptionrequest
        /// <summary>
        /// Creates a new adoption request.
        /// </summary>
        [HttpPost]
        public async Task<IActionResult> CreateAdoptionRequest([FromBody] AdoptionRequestCreateDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState); // Returns 400 if the model is invalid

            var createdAdoptionRequest = await _adoptionrequestService.CreateAdoptionRequestAsync(dto);
            // Returns 201 Created with the URI of the new resource
            return CreatedAtAction(nameof(GetAdoptionRequestById), new { id = createdAdoptionRequest.AdoptionRequestId }, createdAdoptionRequest);
        }

        // PUT: api/adoptionrequest/{id}
        /// <summary>
        /// Updates an existing adoption request by ID.
        /// </summary>
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateAdoptionRequest(Guid id, [FromBody] AdoptionRequestUpdateDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState); // Returns 400 if the model is invalid

            var success = await _adoptionrequestService.UpdateAdoptionRequestAsync(id, dto);
            if (!success)
                return NotFound(); // Returns 404 if the user does not exist

            return NoContent(); // Returns 204 No Content on success
        }

        // DELETE: api/adoptionrequest/{id}
        /// <summary>
        /// Deletes a adoption request by their ID.
        /// </summary>
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAdoptionRequest(Guid id)
        {
            var success = await _adoptionrequestService.DeleteAdoptionRequestAsync(id);
            if (!success)
                return NotFound(); // Returns 404 if the user does not exist

            return NoContent(); // Returns 204 No Content on successful deletion
        }
    }
}
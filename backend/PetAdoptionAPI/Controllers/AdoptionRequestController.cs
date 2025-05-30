using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization; // For authorization attributes
using System;
using System.Threading.Tasks;
using PetAdoptionAPI.Interfaces;   // For IAdoptionRequestService
using PetAdoptionAPI.Dtos;         // For DTOs

namespace PetAdoptionAPI.Controllers
{
    [Authorize] // Ensures that only authenticated users can access this controller
    [ApiController] // Marks this class as an API Controller
    [Route("api/[controller]")] // Base route will be api/adoptionrequest
    public class AdoptionRequestController : ControllerBase
    {
        private readonly IAdoptionRequestService _adoptionRequestService;

        // Constructor with dependency injection of the service
        public AdoptionRequestController(IAdoptionRequestService adoptionRequestService)
        {
            _adoptionRequestService = adoptionRequestService;
        }

        // GET: api/adoptionrequest
        /// <summary>
        /// Retrieves a list of all adoption requests.
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> GetAllAdoptionRequests()
        {
            var requests = await _adoptionRequestService.GetAllAdoptionRequestsAsync();
            return Ok(requests); // Returns 200 OK with the list of adoption requests
        }

        // GET: api/adoptionrequest/{id}
        /// <summary>
        /// Retrieves a specific adoption request by its unique ID.
        /// </summary>
        [HttpGet("{id}")]
        public async Task<IActionResult> GetAdoptionRequestById(Guid id)
        {
            var request = await _adoptionRequestService.GetAdoptionRequestByIdAsync(id);
            if (request == null)
                return NotFound(); // Returns 404 if the request does not exist
            return Ok(request);
        }

        // GET: api/adoptionrequest/user/{userId}
        /// <summary>
        /// Retrieves all adoption requests made by a specific user.
        /// </summary>
        [HttpGet("user/{userId}")]
        public async Task<IActionResult> GetAdoptionRequestsByUserId(Guid userId)
        {
            var requests = await _adoptionRequestService.GetAdoptionRequestsByUserIdAsync(userId);
            return Ok(requests); // Returns 200 OK with the list of requests for the user
        }

        // GET: api/adoptionrequest/animal/{animalId}
        /// <summary>
        /// Retrieves all adoption requests for a specific animal.
        /// </summary>
        [HttpGet("animal/{animalId}")]
        public async Task<IActionResult> GetAdoptionRequestsByAnimalId(Guid animalId)
        {
            var requests = await _adoptionRequestService.GetAdoptionRequestsByAnimalIdAsync(animalId);
            return Ok(requests); // Returns 200 OK with the list of requests for the animal
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

            var createdRequest = await _adoptionRequestService.CreateAdoptionRequestAsync(dto);
            // Returns 201 Created with the URI of the new resource
            return CreatedAtAction(nameof(GetAdoptionRequestById), new { id = createdRequest.AdoptionRequestId }, createdRequest);
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

            var success = await _adoptionRequestService.UpdateAdoptionRequestAsync(id, dto);
            if (!success)
                return NotFound(); // Returns 404 if the request does not exist

            return NoContent(); // Returns 204 No Content on success
        }

        // DELETE: api/adoptionrequest/{id}
        /// <summary>
        /// Deletes an adoption request by its ID.
        /// </summary>
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAdoptionRequest(Guid id)
        {
            var success = await _adoptionRequestService.DeleteAdoptionRequestAsync(id);
            if (!success)
                return NotFound(); // Returns 404 if the request does not exist

            return NoContent(); // Returns 204 No Content on successful deletion
        }
    }
}

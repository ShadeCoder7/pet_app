using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization; // For authorization attributes
using System;
using System.Threading.Tasks;
using PetAdoptionAPI.Interfaces;   // For IShelterService
using PetAdoptionAPI.Dtos;         // For DTOs

namespace PetAdoptionAPI.Controllers
{
    [Authorize] // Ensures that only authenticated users can access this controller
    [ApiController] // Marks this class as an API Controller
    [Route("api/[controller]")] // Base route will be api/shelter
    public class ShelterController : ControllerBase
    {
        private readonly IShelterService _shelterService;

        // Constructor with dependency injection of the service
        public ShelterController(IShelterService shelterService)
        {
            _shelterService = shelterService;
        }

        // GET: api/shelter
        /// <summary>
        /// Retrieves a list of all shelters.
        /// </summary>
        [AllowAnonymous]
        [HttpGet]
        public async Task<IActionResult> GetAllShelters()
        {
            var shelters = await _shelterService.GetAllSheltersAsync();
            return Ok(shelters); // Returns 200 OK with the list of shelters
        }

        // GET: api/shelter/{id}
        /// <summary>
        /// Retrieves a specific shelter by its unique ID.
        /// </summary>
        [AllowAnonymous]
        [HttpGet("{id}")]
        public async Task<IActionResult> GetShelterById(Guid id)
        {
            var shelter = await _shelterService.GetShelterByIdAsync(id);
            if (shelter == null)
                return NotFound(); // Returns 404 if the shelter does not exist
            return Ok(shelter);
        }

        // GET: api/shelter/search?name={name}
        /// <summary>
        /// Retrieves a list of shelters whose name contains the specified value (case-insensitive).
        /// </summary>
        /// <param name="name">The partial or full name to search for.</param>
        /// <returns>A list of shelters matching the name.</returns>
        [AllowAnonymous]
        [HttpGet("search")]
        public async Task<IActionResult> GetSheltersByName([FromQuery] string name)
        {
            var shelters = await _shelterService.GetSheltersByNameAsync(name);
            return Ok(shelters); // Returns 200 OK with the matching shelters
        }

        // POST: api/shelter
        /// <summary>
        /// Creates a new shelter.
        /// </summary>
        [HttpPost]
        public async Task<IActionResult> CreateShelter([FromBody] ShelterCreateDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState); // Returns 400 if the model is invalid

            var createdShelter = await _shelterService.CreateShelterAsync(dto);
            // Returns 201 Created with the URI of the new resource
            return CreatedAtAction(nameof(GetShelterById), new { id = createdShelter.ShelterId }, createdShelter);
        }

        // PUT: api/shelter/{id}
        /// <summary>
        /// Updates an existing shelter by ID.
        /// </summary>
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateShelter(Guid id, [FromBody] ShelterUpdateDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState); // Returns 400 if the model is invalid

            var success = await _shelterService.UpdateShelterAsync(id, dto);
            if (!success)
                return NotFound(); // Returns 404 if the shelter does not exist

            return NoContent(); // Returns 204 No Content on success
        }

        // DELETE: api/shelter/{id}
        /// <summary>
        /// Deletes a shelter by its ID.
        /// </summary>
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteShelter(Guid id)
        {
            var success = await _shelterService.DeleteShelterAsync(id);
            if (!success)
                return NotFound(); // Returns 404 if the shelter does not exist

            return NoContent(); // Returns 204 No Content on successful deletion
        }
    }
}

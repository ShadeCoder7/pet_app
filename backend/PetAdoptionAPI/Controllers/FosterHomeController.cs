using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization; // For authorization attributes
using System;
using System.Threading.Tasks;
using PetAdoptionAPI.Interfaces;   // For IFosterHomeService
using PetAdoptionAPI.Dtos;         // For DTOs

namespace PetAdoptionAPI.Controllers
{
    [Authorize] // Ensures that only authenticated users can access this controller
    [ApiController] // Marks this class as an API Controller
    [Route("api/[controller]")] // Base route will be api/fosterhome
    public class FosterHomeController : ControllerBase
    {
        private readonly IFosterHomeService _fosterHomeService;

        // Constructor with dependency injection of the service
        public FosterHomeController(IFosterHomeService fosterHomeService)
        {
            _fosterHomeService = fosterHomeService;
        }

        // GET: api/fosterhome
        /// <summary>
        /// Retrieves a list of all foster homes.
        /// </summary>
        [AllowAnonymous] // Allows anonymous access to this endpoint
        [HttpGet]
        public async Task<IActionResult> GetAllFosterHomes()
        {
            var fosterHomes = await _fosterHomeService.GetAllFosterHomesAsync();
            return Ok(fosterHomes); // Returns 200 OK with the list of foster homes
        }

        // GET: api/fosterhome/{id}
        /// <summary>
        /// Retrieves a specific foster home by its unique ID.
        /// </summary>
        [AllowAnonymous] // Allows anonymous access to this endpoint
        [HttpGet("{id}")]
        public async Task<IActionResult> GetFosterHomeById(Guid id)
        {
            var fosterHome = await _fosterHomeService.GetFosterHomeByIdAsync(id);
            if (fosterHome == null)
                return NotFound(); // Returns 404 if the foster home does not exist
            return Ok(fosterHome);
        }

        // GET: api/fosterhome/search?name={name}
        /// <summary>
        /// Retrieves a list of foster homes whose name contains the specified value (case-insensitive).
        /// </summary>
        /// <param name="name">The partial or full name to search for.</param>
        /// <returns>A list of foster homes matching the name.</returns>
        [AllowAnonymous] // Allows anonymous access to this endpoint
        [HttpGet("search")]
        public async Task<IActionResult> GetFosterHomesByName([FromQuery] string name)
        {
            var fosterHomes = await _fosterHomeService.GetFosterHomesByNameAsync(name);
            return Ok(fosterHomes); // Returns 200 OK with the matching foster homes
        }

        // POST: api/fosterhome
        /// <summary>
        /// Creates a new foster home.
        /// </summary>
        [HttpPost]
        public async Task<IActionResult> CreateFosterHome([FromBody] FosterHomeCreateDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState); // Returns 400 if the model is invalid

            var createdFosterHome = await _fosterHomeService.CreateFosterHomeAsync(dto);
            // Returns 201 Created with the URI of the new resource
            return CreatedAtAction(nameof(GetFosterHomeById), new { id = createdFosterHome.FosterHomeId }, createdFosterHome);
        }

        // PUT: api/fosterhome/{id}
        /// <summary>
        /// Updates an existing foster home by ID.
        /// </summary>
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateFosterHome(Guid id, [FromBody] FosterHomeUpdateDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState); // Returns 400 if the model is invalid

            var success = await _fosterHomeService.UpdateFosterHomeAsync(id, dto);
            if (!success)
                return NotFound(); // Returns 404 if the foster home does not exist

            return NoContent(); // Returns 204 No Content on success
        }

        // DELETE: api/fosterhome/{id}
        /// <summary>
        /// Deletes a foster home by its ID.
        /// </summary>
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteFosterHome(Guid id)
        {
            var success = await _fosterHomeService.DeleteFosterHomeAsync(id);
            if (!success)
                return NotFound(); // Returns 404 if the foster home does not exist

            return NoContent(); // Returns 204 No Content on successful deletion
        }
    }
}

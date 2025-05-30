using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;
using PetAdoptionAPI.Interfaces;   // For IUserService
using PetAdoptionAPI.Dtos;         // For DTOs

namespace PetAdoptionAPI.Controllers
{
    [ApiController] // Marks this class as an API Controller
    [Route("api/[controller]")]
    public class FosterHomeController : ControllerBase
    {
        private readonly IFosterHomeService _fosterhomeService;

        // Constructor with dependency injection of the service
        public FosterHomeController(IFosterHomeService fosterhomeService)
        {
            _fosterhomeService = fosterhomeService;
        }

        // GET: api/fosterhome
        /// <summary>
        /// Retrieves a list of all foster homes.
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> GetAllFosterHomes()
        {
            var fosterhomes = await _fosterhomeService.GetAllFosterHomesAsync();
            return Ok(fosterhomes); // Returns 200 OK with the list of users
        }

        // GET: api/fosterhome/{id}
        /// <summary>
        /// Retrieves a specific foster home by their unique ID.
        /// </summary>
        [HttpGet("{id}")]
        public async Task<IActionResult> GetFosterHomeById(Guid id)
        {
            var fosterhome = await _fosterhomeService.GetFosterHomeByIdAsync(id);
            if (fosterhome == null)
                return NotFound(); // Returns 404 if the user does not exist
            return Ok(fosterhome);
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

            var createdFosterHome = await _fosterhomeService.CreateFosterHomeAsync(dto);
            // Returns 201 Created with the URI of the new resource
            return CreatedAtAction(nameof(GetFosterHomeById), new { id = createdFosterHome.FosterHomeId }, createdFosterHome);
        }

        // PUT: api/fosterhome/{id}
        /// <summary>
        /// Updates an existing fosterhome by ID.
        /// </summary>
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateFosterHome(Guid id, [FromBody] FosterHomeUpdateDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState); // Returns 400 if the model is invalid

            var success = await _fosterhomeService.UpdateFosterHomeAsync(id, dto);
            if (!success)
                return NotFound(); // Returns 404 if the user does not exist

            return NoContent(); // Returns 204 No Content on success
        }

        // DELETE: api/fosterhome/{id}
        /// <summary>
        /// Deletes a fosterhome by their ID.
        /// </summary>
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteFosterHome(Guid id)
        {
            var success = await _fosterhomeService.DeleteFosterHomeAsync(id);
            if (!success)
                return NotFound(); // Returns 404 if the user does not exist

            return NoContent(); // Returns 204 No Content on successful deletion
        }
    }
}

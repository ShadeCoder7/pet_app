using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;
using PetAdoptionAPI.Interfaces;   // For IAnimalService
using PetAdoptionAPI.Dtos;         // For DTOs

namespace PetAdoptionAPI.Controllers
{
    [ApiController] // Marks this class as an API Controller (automatic model validation, etc.)
    [Route("api/[controller]")] // Defines the route for this controller
    public class AnimalController : ControllerBase
    {
        private readonly IAnimalService _animalService;

        // Constructor with dependency injection of the service
        public AnimalController(IAnimalService animalService)
        {
            _animalService = animalService;
        }

        // GET: api/animal
        /// <summary>
        /// Retrieves a list of all animals.
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> GetAllAnimals()
        {
            var animals = await _animalService.GetAllAnimalsAsync();
            return Ok(animals); // Returns 200 OK with the list of animals
        }

        // GET: api/animal/{id}
        /// <summary>
        /// Retrieves a specific animal by its unique ID.
        /// </summary>
        [HttpGet("{id}")]
        public async Task<IActionResult> GetAnimalById(Guid id)
        {
            var animal = await _animalService.GetAnimalByIdAsync(id);
            if (animal == null)
                return NotFound(); // Returns 404 if the animal does not exist
            return Ok(animal);
        }

        // POST: api/animal
        /// <summary>
        /// Creates a new animal entry.
        /// </summary>
        [HttpPost]
        public async Task<IActionResult> CreateAnimal([FromBody] AnimalCreateDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState); // Returns 400 if the model is invalid

            var createdAnimal = await _animalService.CreateAnimalAsync(dto);
            // Returns 201 Created with the URI of the new resource
            return CreatedAtAction(nameof(GetAnimalById), new { id = createdAnimal.AnimalId }, createdAnimal);
        }

        // PUT: api/animal/{id}
        /// <summary>
        /// Updates the details of an existing animal by ID.
        /// </summary>
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateAnimal(Guid id, [FromBody] AnimalUpdateDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState); // Returns 400 if the model is invalid

            var success = await _animalService.UpdateAnimalAsync(id, dto);
            if (!success)
                return NotFound(); // Returns 404 if the animal does not exist

            return NoContent(); // Returns 204 No Content on success
        }

        // PATCH: api/animal/{id}
        /// <summary>
        /// Partially updates an animal by ID (PATCH).
        /// </summary>
        [HttpPatch("{id}")]
        public async Task<IActionResult> PatchAnimal(Guid id, [FromBody] AnimalPatchDto patchDto)
        {
            if (patchDto == null)
                return BadRequest();

            var success = await _animalService.PatchAnimalAsync(id, patchDto);
            if (!success)
                return NotFound();

            return NoContent();
        }


        // DELETE: api/animal/{id}
        /// <summary>
        /// Deletes an animal by its ID.
        /// </summary>
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAnimal(Guid id)
        {
            var success = await _animalService.DeleteAnimalAsync(id);
            if (!success)
                return NotFound(); // Returns 404 if the animal does not exist

            return NoContent(); // Returns 204 No Content on successful deletion
        }
    }
}


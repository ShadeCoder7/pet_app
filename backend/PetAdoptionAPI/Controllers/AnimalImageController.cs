using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;
using PetAdoptionAPI.Interfaces;   // For IAnimalImageService
using PetAdoptionAPI.Dtos;         // For DTOs

namespace PetAdoptionAPI.Controllers
{
    [ApiController] // Marks this class as an API Controller
    [Route("api/[controller]")] // Base route will be api/animalimage
    public class AnimalImageController : ControllerBase
    {
        private readonly IAnimalImageService _animalImageService;

        // Constructor with dependency injection of the service
        public AnimalImageController(IAnimalImageService animalImageService)
        {
            _animalImageService = animalImageService;
        }

        // GET: api/animalimage
        /// <summary>
        /// Retrieves a list of all animal images.
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> GetAllAnimalImages()
        {
            var images = await _animalImageService.GetAllAnimalImagesAsync();
            return Ok(images); // Returns 200 OK with the list of animal images
        }

        // GET: api/animalimage/animal/{animalId}
        /// <summary>
        /// Retrieves all images for a specific animal by its AnimalId.
        /// </summary>
        [HttpGet("animal/{animalId}")]
        public async Task<IActionResult> GetImagesByAnimalId(Guid animalId)
        {
            var images = await _animalImageService.GetImagesByAnimalIdAsync(animalId);
            return Ok(images); // Returns 200 OK with the list of images for the given animal
        }

        // GET: api/animalimage/{id}
        /// <summary>
        /// Retrieves a specific animal image by its ID.
        /// </summary>
        [HttpGet("{id}")]
        public async Task<IActionResult> GetAnimalImageById(int id)
        {
            var image = await _animalImageService.GetAnimalImageByIdAsync(id);
            if (image == null)
                return NotFound(); // Returns 404 if the animal image does not exist
            return Ok(image);
        }

        // POST: api/animalimage
        /// <summary>
        /// Creates a new animal image.
        /// </summary>
        [HttpPost]
        public async Task<IActionResult> CreateAnimalImage([FromBody] AnimalImageCreateDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState); // Returns 400 if the model is invalid

            var createdImage = await _animalImageService.CreateAnimalImageAsync(dto);
            // Returns 201 Created with the URI of the new resource
            return CreatedAtAction(nameof(GetAnimalImageById), new { id = createdImage.AnimalImageId }, createdImage);
        }

        // PUT: api/animalimage/{id}
        /// <summary>
        /// Updates an existing animal image by ID.
        /// </summary>
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateAnimalImage(int id, [FromBody] AnimalImageUpdateDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState); // Returns 400 if the model is invalid

            var success = await _animalImageService.UpdateAnimalImageAsync(id, dto);
            if (!success)
                return NotFound(); // Returns 404 if the animal image does not exist

            return NoContent(); // Returns 204 No Content on success
        }

        // DELETE: api/animalimage/{id}
        /// <summary>
        /// Deletes an animal image by its ID.
        /// </summary>
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAnimalImage(int id)
        {
            var success = await _animalImageService.DeleteAnimalImageAsync(id);
            if (!success)
                return NotFound(); // Returns 404 if the animal image does not exist

            return NoContent(); // Returns 204 No Content on successful deletion
        }
    }
}

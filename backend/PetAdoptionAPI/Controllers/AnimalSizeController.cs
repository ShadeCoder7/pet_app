using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using PetAdoptionAPI.Interfaces;   // For IAnimalSizeService

namespace PetAdoptionAPI.Controllers
{
    [ApiController] // Marks this class as an API Controller
    [Route("api/[controller]")] // Base route will be api/animalsize
    public class AnimalSizeController : ControllerBase
    {
        private readonly IAnimalSizeService _animalSizeService;

        // Constructor with dependency injection of the service
        public AnimalSizeController(IAnimalSizeService animalSizeService)
        {
            _animalSizeService = animalSizeService;
        }

        // GET: api/animalsize
        /// <summary>
        /// Retrieves a list of all animal sizes.
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> GetAllAnimalSizes()
        {
            var animalSizes = await _animalSizeService.GetAllAnimalSizesAsync();
            return Ok(animalSizes); // Returns 200 OK with the list of animal sizes
        }

        // GET: api/animalsize/{key}
        /// <summary>
        /// Retrieves a specific animal size by its key.
        /// </summary>
        [HttpGet("{key}")]
        public async Task<IActionResult> GetAnimalSizeByKey(string key)
        {
            var animalSize = await _animalSizeService.GetAnimalSizeByKeyAsync(key);
            if (animalSize == null)
                return NotFound(); // Returns 404 if the animal size does not exist
            return Ok(animalSize);
        }
    }
}

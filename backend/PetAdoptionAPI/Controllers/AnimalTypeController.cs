using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using PetAdoptionAPI.Interfaces;   // For IAnimalTypeService

namespace PetAdoptionAPI.Controllers
{
    [ApiController] // Marks this class as an API Controller
    [Route("api/[controller]")] // Base route will be api/animaltype
    public class AnimalTypeController : ControllerBase
    {
        private readonly IAnimalTypeService _animalTypeService;

        // Constructor with dependency injection of the service
        public AnimalTypeController(IAnimalTypeService animalTypeService)
        {
            _animalTypeService = animalTypeService;
        }

        // GET: api/animaltype
        /// <summary>
        /// Retrieves a list of all animal types.
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> GetAllAnimalTypes()
        {
            var animalTypes = await _animalTypeService.GetAllAnimalTypesAsync();
            return Ok(animalTypes); // Returns 200 OK with the list of animal types
        }

        // GET: api/animaltype/{key}
        /// <summary>
        /// Retrieves a specific animal type by its key.
        /// </summary>
        [HttpGet("{key}")]
        public async Task<IActionResult> GetAnimalTypeByKey(string key)
        {
            var animalType = await _animalTypeService.GetAnimalTypeByKeyAsync(key);
            if (animalType == null)
                return NotFound(); // Returns 404 if the animal type does not exist
            return Ok(animalType);
        }
    }
}

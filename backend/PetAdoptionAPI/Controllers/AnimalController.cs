// pet_app/backend/PetAdoptionAPI/Controllers/AnimalsController.cs

using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PetAdoptionAPI.Data;
using PetAdoptionAPI.Models;

namespace PetAdoptionAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AnimalsController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public AnimalsController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: api/Animals
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Animal>>> GetAnimals()
        {
            return await _context.Animals.ToListAsync();
        }

        // POST: api/Animals
        [HttpPost]
        public async Task<ActionResult<Animal>> PostAnimal(Animal animal)
        {
            _context.Animals.Add(animal);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetAnimal", new { id = animal.AnimalId }, animal);
        }
    }
}

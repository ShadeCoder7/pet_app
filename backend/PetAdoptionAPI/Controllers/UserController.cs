using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization; // For authorization attributes
using System;
using System.Threading.Tasks;
using PetAdoptionAPI.Interfaces;   // For IUserService
using PetAdoptionAPI.Dtos;         // For DTOs

namespace PetAdoptionAPI.Controllers
{
    // All actions require authentication except user registration (POST), which is public.
    [Authorize] // Ensures that only authenticated users can access this controller
    [ApiController] // Marks this class as an API Controller
    [Route("api/[controller]")]
    public class UserController : ControllerBase
    {
        private readonly IUserService _userService;

        // Constructor with dependency injection of the service
        public UserController(IUserService userService)
        {
            _userService = userService;
        }

        // GET: api/user
        /// <summary>
        /// Retrieves a list of all users.
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> GetAllUsers()
        {
            var users = await _userService.GetAllUsersAsync();
            return Ok(users); // Returns 200 OK with the list of users
        }

        // GET: api/user/{id}
        /// <summary>
        /// Retrieves a specific user by their unique ID.
        /// </summary>
        [HttpGet("{id}")]
        public async Task<IActionResult> GetUserById(Guid id)
        {
            var user = await _userService.GetUserByIdAsync(id);
            if (user == null)
                return NotFound(); // Returns 404 if the user does not exist
            return Ok(user);
        }

        // GET: api/user/firebase/{firebaseUid}
        /// <summary>
        /// Retrieves a user by their Firebase UID.
        /// </summary>
        [AllowAnonymous]
        [HttpGet("firebase/{firebaseUid}")]
        public async Task<IActionResult> GetUserByFirebaseUid(string firebaseUid)
        {
            var user = await _userService.GetUserByFirebaseUidAsync(firebaseUid);
            if (user == null)
                return NotFound();
            return Ok(user);
        }

        // POST: api/user
        /// <summary>
        /// Creates a new user.
        /// </summary>
        [AllowAnonymous] // Allows anonymous access to this endpoint
        [HttpPost]
        public async Task<IActionResult> CreateUser([FromBody] UserCreateDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState); // Returns 400 if the model is invalid

            var createdUser = await _userService.CreateUserAsync(dto);
            // Returns 201 Created with the URI of the new resource
            return CreatedAtAction(nameof(GetUserById), new { id = createdUser.UserId }, createdUser);
        }

        // PUT: api/user/{id}
        /// <summary>
        /// Updates an existing user by ID.
        /// </summary>
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateUser(Guid id, [FromBody] UserUpdateDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState); // Returns 400 if the model is invalid

            var success = await _userService.UpdateUserAsync(id, dto);
            if (!success)
                return NotFound(); // Returns 404 if the user does not exist

            return NoContent(); // Returns 204 No Content on success
        }

        // PATCH: api/user/{id}
        /// <summary>
        /// Partially updates user data by their ID.
        /// </summary>
        [HttpPatch("{id}")]
        public async Task<IActionResult> PatchUser(Guid id, [FromBody] UserPatchDto dto)
        {
            // Check if the request model is valid
            if (!ModelState.IsValid)
                return BadRequest(ModelState); // Returns 400 Bad Request if the model is invalid

            // Try to update the user with the given ID using the provided data
            var success = await _userService.PatchUserAsync(id, dto);
            if (!success)
                return NotFound(); // Returns 404 if the user does not exist

            return NoContent(); // Returns 204 No Content on success
        }



        // DELETE: api/user/{id}
        /// <summary>
        /// Deletes a user by their ID.
        /// </summary>
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(Guid id)
        {
            var success = await _userService.DeleteUserAsync(id);
            if (!success)
                return NotFound(); // Returns 404 if the user does not exist

            return NoContent(); // Returns 204 No Content on successful deletion
        }
    }
}

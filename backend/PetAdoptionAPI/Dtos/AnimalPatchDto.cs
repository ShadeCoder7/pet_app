// DTO used for partial updates (PATCH requests) on animal data.
namespace PetAdoptionAPI.Dtos
{
    public class AnimalPatchDto
    {
        // Allows updating the animal's name (optional).
        public string? AnimalName { get; set; }
        
        // Allows updating the animal's age (optional).
        public int? AnimalAge { get; set; }
        
        // Allows updating the animal's gender (optional).
        public string? AnimalGender { get; set; }
        
        // Allows updating the animal's breed (optional).
        public string? AnimalBreed { get; set; }
        
        // Allows updating the animal's description (optional).
        public string? AnimalDescription { get; set; }
        
        // Allows updating the animal's status (optional).
        public string? AnimalStatus { get; set; }
        
        // Allows updating the animal's location (optional).
        public string? AnimalLocation { get; set; }
        
        // Allows updating the animal's latitude (optional).
        public double? AnimalLatitude { get; set; }
        
        // Allows updating the animal's longitude (optional).
        public double? AnimalLongitude { get; set; }
        
        // Allows updating the reference key for the animal's type (optional).
        public string? AnimalTypeKey { get; set; }
        
        // Allows updating the reference key for the animal's size (optional).
        public string? AnimalSizeKey { get; set; }
        
        // Allows updating the ID of the user who adds the animal (optional).
        public Guid? UserId { get; set; }
        
        // Allows updating the ID of the associated shelter (optional).
        public Guid? ShelterId { get; set; }
        
        // Allows updating the ID of the associated foster home (optional).
        public Guid? FosterHomeId { get; set; }
    }
}

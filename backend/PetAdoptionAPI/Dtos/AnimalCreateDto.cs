// DTO used when creating a new animal (POST request).
namespace PetAdoptionAPI.Dtos
{
    public class AnimalCreateDto
    {
        // Name of the animal.
        public string AnimalName { get; set; }
        // Age of the animal (nullable).
        public int? AnimalAge { get; set; }
        // Gender of the animal.
        public string AnimalGender { get; set; }
        // Breed of the animal.
        public string AnimalBreed { get; set; }
        // Description or additional details about the animal.
        public string AnimalDescription { get; set; }
        // Status (e.g., available, adopted, etc.).
        public string AnimalStatus { get; set; }
        // General location or address where the animal is.
        public string AnimalLocation { get; set; }
        // Latitude (nullable).
        public double? AnimalLatitude { get; set; }
        // Longitude (nullable).
        public double? AnimalLongitude { get; set; }
        // Reference key for the animal's type.
        public string AnimalTypeKey { get; set; }
        // Reference key for the animal's size.
        public string AnimalSizeKey { get; set; }
        // (Optional) ID of the user who adds the animal.
        public Guid? UserId { get; set; }
        // (Optional) ID of the associated shelter.
        public Guid? ShelterId { get; set; }
        // (Optional) ID of the associated foster home.
        public Guid? FosterHomeId { get; set; }
    }
}

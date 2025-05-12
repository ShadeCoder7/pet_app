// Models/AnimalImage.cs
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PetAdoptionAPI.Models
{
    [Table("animal_images")]
    public class AnimalImage
    {
        // Unique ID for the animal image, with the setter private (only the database can set it)
        [Key]
        public int AnimalImageId { get; private set; }

        // URL of the image
        [Required]
        public string ImageUrl { get; set; }

        // Date when the image was uploaded
        public DateTime UploadDate { get; set; } = DateTime.Now;

        // Alternative text for the image (for accessibility)
        public string ImageAlternativeText { get; set; }

        // Description of the image
        public string ImageDescription { get; set; }

        // Whether it is the main image for the animal
        public bool IsMainImage { get; set; } = false;

        // Whether the image is verified by an admin
        public bool ImageIsVerified { get; set; } = false;

        // Foreign key to the animal associated with the image
        [ForeignKey("AnimalId")]
        public Guid AnimalId { get; set; }

        // Navigation property to access related animal information
        public Animal Animal { get; set; }
    }
}

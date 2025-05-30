using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PetAdoptionAPI.Models
{

    [Table("animal_images")]
    public class AnimalImage
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        [Column("animal_image_id")]
        public int AnimalImageId { get; set; }  // Unique auto-incremented ID for the animal image

        [Required]
        [Column("image_url")]
        public string ImageUrl { get; set; }  // URL of the image

        [Column("upload_date")]
        public DateTime UploadDate { get; set; } = DateTime.UtcNow;  // Upload date

        [Column("image_alternative_text")]
        public string? ImageAlternativeText { get; set; }  // Alternative text (accessibility)

        [Column("image_description")]
        public string? ImageDescription { get; set; }  // Description of the image

        [Column("is_main_image")]
        public bool IsMainImage { get; set; } = false;  // Is this the main image for the animal?

        [Column("image_is_verified")]
        public bool ImageIsVerified { get; set; } = false;  // Verified by admin

        [Required]
        [Column("animal_id")]
        public Guid AnimalId { get; set; }  // Foreign key to associated animal

        // Navigation property
        [ForeignKey("AnimalId")]
        public Animal Animal { get; set; }
    }
}

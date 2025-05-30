using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PetAdoptionAPI.Models
{

    [Table("animal_types")]
    public class AnimalType
    {
        [Key]
        [Column("animal_type_key")]
        [StringLength(30)]
        public string AnimalTypeKey { get; set; }  // Unique key for the animal type (e.g., dog, cat, etc.)

        [Required]
        [Column("animal_type_label")]
        [StringLength(50)]
        public string AnimalTypeLabel { get; set; }  // Display label (e.g., "Dog", "Cat", etc.)
    }
}


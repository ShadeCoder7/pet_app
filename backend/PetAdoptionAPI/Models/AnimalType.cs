// Models/AnimalType.cs
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PetAdoptionAPI.Models
{
    [Table("animal_types")]
    public class AnimalType
    {
        [Key]
        public string AnimalTypeKey { get; set; }  // Key for the animal type (e.g., "dog", "cat")

        [Required]
        [MaxLength(50)]
        public string AnimalTypeLabel { get; set; }  // Display label for the animal type (e.g., "Dog", "Cat")
    }
}

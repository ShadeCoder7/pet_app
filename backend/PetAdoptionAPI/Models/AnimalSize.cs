// Models/AnimalSize.cs
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PetAdoptionAPI.Models
{
    [Table("animal_sizes")]
    public class AnimalSize
    {
        [Key]
        public string AnimalSizeKey { get; set; }  // Key that identifies the animal size category (small, medium, large)

        [Required]
        [MaxLength(50)]
        public string AnimalSizeLabel { get; set; }  // Display label for the size (e.g., "Small", "Medium")

        [Required]
        public string AnimalSizeDescription { get; set; }  // Description for the size (e.g., "Up to 10 kg", "10 to 25 kg")
    }
}

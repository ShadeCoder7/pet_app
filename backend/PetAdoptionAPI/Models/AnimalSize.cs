using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PetAdoptionAPI.Models
{

    [Table("animal_sizes")]
    public class AnimalSize
    {
        [Key]
        [Column("animal_size_key")]
        public string AnimalSizeKey { get; set; } // small, medium, large

        [Required]
        [Column("animal_size_label")]
        [StringLength(50)]
        public string AnimalSizeLabel { get; set; } // Display label

        [Required]
        [Column("animal_size_description")]
        public string AnimalSizeDescription { get; set; } // Description
    }
}
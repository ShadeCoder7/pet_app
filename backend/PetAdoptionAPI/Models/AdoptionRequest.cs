// Models/AdoptionRequest.cs
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PetAdoptionAPI.Models
{
    [Table("adoption_requests")]
    public class AdoptionRequest
    {
        // Unique ID for the adoption request
        [Key]
        public Guid AdoptionRequestId { get; private set; } // Set private to make it immutable outside the class

        // When the request was made
        public DateTime RequestDate { get; set; } = DateTime.Now;

        // When the request was last updated
        public DateTime RequestUpdateDate { get; set; } = DateTime.Now;

        // Status of the request (pending, approved, rejected)
        [Required]
        [MaxLength(20)]
        public string RequestStatus { get; set; }

        // Message from the user
        public string RequestMessage { get; set; }

        // Response from the shelter or admin
        public string RequestResponse { get; set; }

        // When the response was given
        public DateTime? RequestResponseDate { get; set; }

        // Whether the request is verified
        public bool RequestIsVerified { get; set; } = false;

        // Whether the request is completed
        public bool RequestIsCompleted { get; set; } = false;

        // Foreign key to the user who made the request
        [ForeignKey("UserId")]
        public Guid UserId { get; set; }

        // Foreign key to the animal for which the request was made
        [ForeignKey("AnimalId")]
        public Guid AnimalId { get; set; }

        // Navigation property to related user and animal entities
        public User User { get; set; }
        public Animal Animal { get; set; }
    }
}

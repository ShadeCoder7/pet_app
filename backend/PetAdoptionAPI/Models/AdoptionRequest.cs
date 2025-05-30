using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;


namespace PetAdoptionAPI.Models
{
    [Table("adoption_requests")]
    public class AdoptionRequest
    {
        [Key]
        [Column("adoption_request_id")]
        public Guid AdoptionRequestId { get; set; }  // Unique ID for the request

        [Column("request_date")]
        public DateTime RequestDate { get; set; } = DateTime.UtcNow;  // When the request was made

        [Column("request_update_date")]
        public DateTime RequestUpdateDate { get; set; } = DateTime.UtcNow;  // When last updated

        [Required]
        [Column("request_status")]
        [StringLength(20)]
        [RegularExpression("^(pending|approved|rejected)$", ErrorMessage = "Invalid request status.")]
        public string RequestStatus { get; set; }  // Status of the request

        [Column("request_message")]
        public string? RequestMessage { get; set; }  // Message from the user (optional)

        [Column("request_response")]
        public string? RequestResponse { get; set; }  // Response from shelter/admin (optional)

        [Column("request_response_date")]
        public DateTime? RequestResponseDate { get; set; }  // When the response was given (optional)

        [Column("request_is_verified")]
        public bool RequestIsVerified { get; set; } = false;  // Whether the request is verified

        [Column("request_is_completed")]
        public bool RequestIsCompleted { get; set; } = false;  // Whether the request is completed

        [Required]
        [Column("user_id")]
        public Guid UserId { get; set; }  // User who made the request

        [Required]
        [Column("animal_id")]
        public Guid AnimalId { get; set; }  // Animal for which the request was made

        // Navigation properties
        [ForeignKey("UserId")]
        public User User { get; set; }

        [ForeignKey("AnimalId")]
        public Animal Animal { get; set; }
    }
}

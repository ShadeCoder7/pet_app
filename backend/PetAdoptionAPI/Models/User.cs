// Models/User.cs
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PetAdoptionAPI.Models
{
    [Table("users")]
    public class User
    {
        [Key]
        public Guid UserId { get; private set; }  // UUID como clave primaria

        [Required]
        [StringLength(100)]
        public string UserEmail { get; set; }  // Email del usuario

        [Required]
        public string UserPassword { get; set; }  // Contraseña cifrada

        [Required]
        [StringLength(20)]
        public string UserRole { get; set; }  // Rol del usuario

        public bool IsRoleVerified { get; set; }  // Verificación del rol por un admin

        [Required]
        [StringLength(100)]
        public string UserFirstName { get; set; }  // Primer nombre del usuario

        [Required]
        [StringLength(100)]
        public string UserLastName { get; set; }  // Apellido del usuario

        [Required]
        [StringLength(20)]
        public string UserPhoneNumber { get; set; }  // Número de teléfono del usuario

        public string UserAddress { get; set; }  // Dirección del usuario (opcional)

        public DateTime CreateUserDate { get; set; } = DateTime.UtcNow;  // Fecha de creación de la cuenta

        [Required]
        public DateTime UserBirthDate { get; set; }  // Fecha de nacimiento del usuario

        public string UserProfilePicture { get; set; }  // URL o ruta de la foto de perfil

        public bool UserIsVerified { get; set; } = false;  // Verificación del usuario (por ejemplo, correo)
    }
}

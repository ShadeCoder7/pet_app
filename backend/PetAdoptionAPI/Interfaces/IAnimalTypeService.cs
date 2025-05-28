using System.Collections.Generic;
using System.Threading.Tasks;
using PetAdoptionAPI.Dtos;

namespace PetAdoptionAPI.Interfaces
{
    public interface IAnimalTypeService
    {
        Task<List<AnimalTypeReadDto>> GetAllAnimalTypesAsync();
        Task<AnimalTypeReadDto> GetAnimalTypeByKeyAsync(string animalTypeKey);
    }
}

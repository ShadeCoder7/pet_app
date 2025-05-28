using System.Collections.Generic;
using System.Threading.Tasks;
using PetAdoptionAPI.Dtos;

namespace PetAdoptionAPI.Interfaces
{
    public interface IAnimalSizeService
    {
        Task<List<AnimalSizeReadDto>> GetAllAnimalSizesAsync();
        Task<AnimalSizeReadDto> GetAnimalSizeByKeyAsync(string animalSizeKey);
    }
}

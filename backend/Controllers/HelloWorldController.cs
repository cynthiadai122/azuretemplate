using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MyWebApi.Entities;

[Route("api/[controller]")]
[ApiController]
public class HelloWorldController : ControllerBase
{
    private readonly TestDbContext _context;

    public HelloWorldController(TestDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public ActionResult<string> HelloWorld()
    {
        return "Hello world";
    }
}

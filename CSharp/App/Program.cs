var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

int counter = 0;

// app.MapGet("/", () => "Hello World!");

// Everytime the user hits the /hello endpoint, the counter will increment by 1
app.MapGet("/hello", () => {
    counter++;
    return Results.Json(new {
        message = "Hello World",
        requestCount = counter
    });
});

app.Run();

<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/styles.css" />
    <script src="/app.js" />
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
</head>

<body>
  <div class="container">
    <div class="row mb-3">
      <label for="todo-title" class="form-label">Title</label>
      <input class="form-control" id="todo-title"/>
    </div>
    <div class="row mb-3">
      <label for="todo-content" class="form-label">Content</label>
      <textarea class="form-control" id="todo-content"></textarea>
    </div>
    <div class="row mb-3">
      <button type="button" id="btn-submit" class="btn btn-primary">Submit</button>
    </div>

    <div class="card">
      <div class="card-body">
        <div class="col-sm-4">
          <input type="text" class="form-control" placeholder="Title to search" id='search-title' aria-label="City">
        </div>
        <div class="col-sm">
          <button type="button" id="btn-search" class="btn btn-primary">Search</button>
        </div>
      </div>
    </div>

  </div>
</body>
</html>

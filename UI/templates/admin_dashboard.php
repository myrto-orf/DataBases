<!-- admin_dashboard.php -->
<?php
session_start();
// Check if the user is logged in and is an admin
if (!isset($_SESSION['loggedin']) || $_SESSION['privilege'] != 'admin') {
    header('Location: index.php');
    exit;
}

// Database connection settings
$servername = "localhost";
$dbname = "cooking_competition";
$dbusername = "root"; // Use your MySQL username
$dbpassword = "password";     // Use your MySQL password

// Create connection
$conn = new mysqli($servername, $dbusername, $dbpassword, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Handle add/delete operations
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['add'])) {
        // Handle add operation
        $table = $_POST['table'];
        $column = $_POST['column'];
        $value = $_POST['value'];
        $sql = "INSERT INTO $table ($column) VALUES ($value)";
        if ($conn->query($sql) === TRUE) {
            echo "Record added successfully";
        } else {
            echo "Error adding record: " . $conn->error;
        }
    } elseif (isset($_POST['delete'])) {
        // Handle delete operation
        $table2 = $_POST['table2'];
        $column2 = $_POST['column2'];
        $id = $_POST['id'];
        $sql = "DELETE FROM $table2 WHERE $column2 = $id";
        if ($conn->query($sql) === TRUE) {
            echo "Record deleted successfully";
        } else {
            echo "Error deleting record: " . $conn->error;
        }
    }
}

// Handle query operations
if (isset($_GET['query'])) {
    $query = $_GET['query'];
    $result = $conn->query($query);

    if ($result->num_rows > 0) {
        echo "<table><tr>";
        // Print column headers
        while ($field = $result->fetch_field()) {
            echo "<th>" . $field->name . "</th>";
        }
        echo "</tr>";
        // Print rows
        while ($row = $result->fetch_assoc()) {
            echo "<tr>";
            foreach ($row as $cell) {
                echo "<td>" . $cell . "</td>";
            }
            echo "</tr>";
        }
        echo "</table>";
    } else {
        echo "0 results";
    }
}

$conn->close();
?>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
</head>
<body>
    <h1>Admin Dashboard</h1>
    <form method="GET" action="admin_dashboard.php">
        <label for="query">SQL Query:</label><br>
        <input type="text" id="query" name="query"><br><br>
        <input type="submit" value="Run Query">
    </form>
    <h2>Add Record</h2>
    
    <form method="POST" action="admin_dashboard.php">
        <label for="table">Table:</label><br>
        <input type="text" id="table" name="table" required><br>
        <label for="column">Column:</label><br>
        <input type="text" id="column" name="column" required><br>
        <label for="value">Value:</label><br>
        <input type="text" id="value" name="value" required><br><br>
        <input type="submit" name="add" value="Add Record">
    </form>
    <h2>Delete Record</h2>
    <form method="POST" action="admin_dashboard.php">
        <label for="table2">Table:</label><br>
        <input type="text" id="table2" name="table2" required><br>
        <label for="column2">Column:</label><br>
        <input type="text" id="column2" name="column2" required><br>
        <label for="id">ID:</label><br>
        <input type="text" id="id" name="id" required><br><br>
        <input type="submit" name="delete" value="Delete Record">
    </form>
    <a href="logout.php">Logout</a><br>
    <a href="create_user.php">Create New User</a>
    <style>
        /* CSS styles for the image */
        img {
            max-width: 80%; /* Ensures the image doesn't exceed the width of its container */
            height: auto; /* Maintains aspect ratio */
            display: block; /* Ensures image behaves like a block element */
            margin: 0 auto; /* Centers the image horizontally */
        }
    </style>
    <br><br><h4>Relational Diagram</h4>
    <img src="..\..\schema\relational.png" alt="relational diagram">
</body>
</html>

<!-- cook_dashboard.php -->
<?php
session_start();
// Check if the user is logged in and is a cook
if (!isset($_SESSION['loggedin']) || $_SESSION['privilege'] != 'cook') {
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
    <title>Cook Dashboard</title>
</head>
<body>
    <h1>Cook Dashboard</h1>
    <form method="GET" action="cook_dashboard.php">
        <label for="query">SQL Query:</label><br>
        <input type="text" id="query" name="query"><br><br>
        <input type="submit" value="Run Query">
    </form>
    <a href="logout.php">Logout</a>
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

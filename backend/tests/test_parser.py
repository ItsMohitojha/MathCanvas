import pytest

from core.errors import ParseError
from engine.parser import classify_expression, clean_latex, parse_to_sympy_str


def test_clean_latex():
    # Fractions
    assert clean_latex(r"\frac{1}{2}") == "((1)/(2))"
    assert clean_latex(r"\frac{\frac{1}{2}}{3}") == "((((1)/(2)))/(3))"

    # Operators and functions
    assert clean_latex(r"2 \cdot 3") == "2 * 3"
    assert clean_latex(r"2 \times 3") == "2 * 3"
    assert clean_latex(r"2 \div 3") == "2 / 3"
    assert clean_latex(r"\sin(x)") == "sin(x)"
    assert clean_latex(r"\log(x)") == "log(x)"
    assert clean_latex(r"\exp(x)") == "exp(x)"
    assert clean_latex(r"\sqrt{x}") == "sqrt{x}"

    # Brackets
    assert clean_latex(r"\left( x \right)") == "( x )"
    assert clean_latex(r"\left[ x \right]") == "[ x ]"
    assert clean_latex(r"\left\{ x \right\}") == "{ x }"

    # Variables
    assert clean_latex(r"\pi \alpha \beta \gamma \theta") == "pi alpha beta gamma theta"

    # Exponents
    assert clean_latex(r"x^2") == "x**2"
    assert clean_latex(r"x^{2+y}") == "x**(2+y)"


def test_parse_to_sympy_str():
    assert parse_to_sympy_str("2x + 4") == "2x + 4"
    assert parse_to_sympy_str("2x + 4 = 8") == "Eq(2x + 4, 8)"

    with pytest.raises(ParseError) as exc:
        parse_to_sympy_str("2x + 4 = 8 = 10")
    assert "Multiple '=' characters" in str(exc.value)

    with pytest.raises(ParseError):
        parse_to_sympy_str("2x * * 4")


def test_classify_expression():
    assert classify_expression("2 + 4 * 8") == "arithmetic"
    assert classify_expression("2x + 4 = 8") == "equation"
    assert classify_expression("y = x^2") == "function"
    assert classify_expression("f(x) = x^2") == "function"
    assert classify_expression("a = 5") == "assignment"
    assert classify_expression("my_var = 10") == "assignment"
    assert classify_expression("x^2 + 4x + 4") == "expression"
    assert classify_expression(r"\sin(x)") == "function"
    assert classify_expression(r"\sin(y)") == "expression"

def test_parse_expression_coverage():
    # To cover `parse_expression` method (though unused directly by the parse endpoint, it exists in parser.py)
    from engine.parser import parse_expression

    expr = parse_expression("2x + 4")
    assert str(expr) == "2*x + 4"

    with pytest.raises(ParseError):
        parse_expression("2x * * 4")

def test_clean_latex_edge_cases():
    # Empty string
    assert clean_latex("") == ""

    # Missing braces in fraction shouldn't loop infinitely
    assert clean_latex(r"\frac{1 2") == r"frac{1 2"

    # Unmatched braces
    assert clean_latex(r"\frac{1}{2") == r"frac{1}{2"
    assert clean_latex(r"\frac{1}2}") == r"frac{1}2}"

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

    # Malformed frac tags without braces
    assert clean_latex(r"\frac") == r"frac"
    assert clean_latex(r"\frac a b") == r"frac a b"

    # Nested denominator fraction to cover brace_count += 1
    assert clean_latex(r"\frac{1}{\frac{2}{3}}") == "((1)/(((2)/(3))))"

def test_analyze_expression_edge_cases(mocker):
    from engine.parser import analyze_expression, parse_to_sympy_str
    from engine.parser import parse_expression as real_parse

    # Test parse_expression failure in parse_to_sympy_str
    with pytest.raises(ParseError):
        parse_to_sympy_str("x + * / - y")

    # Mock parse_expression to raise an exception conditionally to hit the recovery blocks
    def mock_parse(expr_str):
        if expr_str in ("5", "x"):
            raise ValueError("mock parse error")
        return real_parse(expr_str)

    mocker.patch("engine.parser.parse_expression", side_effect=mock_parse)

    # Malformed assignment
    res1 = analyze_expression("a = 5")
    assert res1["dependencies"] == []
    assert res1["type"] == "assignment"

    # Malformed function
    res2 = analyze_expression("f(x) = x")
    assert res2["dependencies"] == []
    assert res2["type"] == "function"

    # Malformed shorthand function
    res3 = analyze_expression("y = x")
    assert res3["dependencies"] == []
    assert res3["type"] == "function"


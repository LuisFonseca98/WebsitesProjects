<?php

use Twig\Environment;
use Twig\Error\LoaderError;
use Twig\Error\RuntimeError;
use Twig\Extension\SandboxExtension;
use Twig\Markup;
use Twig\Sandbox\SecurityError;
use Twig\Sandbox\SecurityNotAllowedTagError;
use Twig\Sandbox\SecurityNotAllowedFilterError;
use Twig\Sandbox\SecurityNotAllowedFunctionError;
use Twig\Source;
use Twig\Template;

/* display/results/table.twig */
class __TwigTemplate_0247b8303c3a2e278c95e6ab1a7eb391053ec1e35a99ca6569d99b4bffa9e7db extends \Twig\Template
{
    private $source;
    private $macros = [];

    public function __construct(Environment $env)
    {
        parent::__construct($env);

        $this->source = $this->getSourceContext();

        $this->parent = false;

        $this->blocks = [
        ];
    }

    protected function doDisplay(array $context, array $blocks = [])
    {
        $macros = $this->macros;
        // line 1
        echo ($context["sql_query_message"] ?? null);
        echo "
";
        // line 2
        echo ($context["navigation"] ?? null);
        echo "
";
        // line 3
        echo ($context["headers"] ?? null);
        echo "
<tbody>
    ";
        // line 5
        echo ($context["body"] ?? null);
        echo "
</tbody>
</table>
</div>
";
        // line 9
        echo ($context["multi_row_operation_links"] ?? null);
        echo "
";
        // line 10
        echo ($context["navigation"] ?? null);
        echo "
";
        // line 11
        echo ($context["operations"] ?? null);
        echo "
";
    }

    public function getTemplateName()
    {
        return "display/results/table.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  65 => 11,  61 => 10,  57 => 9,  50 => 5,  45 => 3,  41 => 2,  37 => 1,);
    }

    public function getSourceContext()
    {
        return new Source("", "display/results/table.twig", "C:\\xampp\\phpMyAdmin\\templates\\display\\results\\table.twig");
    }
}
